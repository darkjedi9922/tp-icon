using Gtk;

/**
 * What is important to note is that this class is specifically described as being a
 * subclass of GLib.Object. This is because Vala allows other types of class, but in
 * most cases, this is the sort that you want. In fact, some language features of
 * Vala are only allowed if your class is descended from GLib's Object.
 */
public class TpIconApp : GLib.Object
{
    class TpIcon
    {
        private StatusIcon icon;
        private Gtk.Menu menu;

        public TpIcon()
        {
            icon = new StatusIcon();
            icon.set_visible(true);
            icon.set_has_tooltip(true);
            icon.query_tooltip.connect(updateTooltip);
            icon.popup_menu.connect(popupMenu);
            updateIcon();
            
            menu = new Gtk.Menu();
            var menuQuit = new ImageMenuItem.from_stock(Stock.QUIT, null);
            menuQuit.activate.connect(Gtk.main_quit);
            menu.append(menuQuit);
            menu.show_all();
        }

        public void updateIcon()
        {
            string file;
            int temperature = getCurrentTemperature();
            if (temperature < 40) file = "./icons/ok-0.png";
            else if (temperature < 45) file = "./icons/ok-1.png";
            else if (temperature < 50) file = "./icons/ok-2.png";
            else if (temperature < 55) file = "./icons/warning-1.png";
            else if (temperature < 70) file = "./icons/warning-2.png";
            else file = "./icons/bad-1.png";
            icon.set_from_file(file);
        }

        public int getCurrentTemperature()
        {
            try {
                string sensorsResult;
                Process.spawn_command_line_sync("sensors", out sensorsResult);
                string[] lines = sensorsResult.split("\n");

                double temperatureCount = 0;
                int temperatures = 0;
                for (int i = 0; i < lines.length; ++i) {
                    if (!lines[i].contains("°C")) continue;
                    string temperature = lines[i].split("°C")[0].split("+")[1];
                    temperatureCount += double.parse(temperature);
                    temperatures += 1;
                }
                int average = (int) GLib.Math.round(temperatureCount / temperatures);
                return average;
            } catch (SpawnError e) {
                print("Error: %s\n", e.message);
                return 0;
            }
        }

        /**
         * Иконку нужно обновлять на потоке GTK интерфейса.
         * Можно использовать костыль с Gdk.threads_init/enter/leave(),
         * но он deprecated. Другой выход - использовать GLib.Idle.add(), 
         * который делает как раз то, что нужно.  
         */
        public void run()
        {
            Thread<int> thread = new Thread<int>.try("", () => {
                while (true) {
                    Thread.usleep(1000000);
                    GLib.Idle.add(() => {
                        updateIcon();
                        return false;
                    });
                }
            });
        }

        public bool updateTooltip(int x, int y, bool keyboard_mode, Tooltip tooltip)
        {
            icon.set_tooltip_text("+" + getCurrentTemperature().to_string() + "°C");
            return false;
        }

        private void popupMenu(uint button, uint time) {
            menu.popup(null, null, null, button, time);
        }
    }

	public static int main(string[] args)
	{
        Gtk.init(ref args);
        var icon = new TpIcon();
        icon.run();
        Gtk.main();
		return 0;
	}
}