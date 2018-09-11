using Gtk;

/**
 * What is important to note is that this class is specifically described as being a subclass of GLib.Object. 
 * This is because Vala allows other types of class, but in most cases, this is the sort that you want. 
 * In fact, some language features of Vala are only allowed if your class is descended from GLib's Object.
 */
public class TpIconApp : GLib.Object
{
    class TpIcon
    {
        private StatusIcon icon;

        public TpIcon()
        {
            icon = new StatusIcon();
            icon.set_visible(true);
            updateIcon();
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
                string result;
                Process.spawn_command_line_sync("sh ./tp.sh", out result);
                return int.parse(result);
            } catch (SpawnError e) {
                print ("Error: %s\n", e.message);
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