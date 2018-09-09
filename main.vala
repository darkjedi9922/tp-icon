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
            icon.set_from_stock(Stock.OK);
        }
    }

	public static int main(string[] args)
	{
        Gtk.init(ref args);
        var icon = new TpIcon();
        Gtk.main();
		return 0;
	}
}