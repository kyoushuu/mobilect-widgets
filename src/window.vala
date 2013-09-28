/*
 * Copyright (c) 2013 Mobilect Power Corp.
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Author: Arnel A. Borja <kyoushuu@yahoo.com>
 *
 */

using Gtk;
using Gd;

public class Mpcw.Window : ApplicationWindow {

    public HeaderBar headerbar;
    public HeaderSimpleButton button_back;
    public Stack stack;
    public Notification notification;

    construct {
        try {
            Gd.ensure_types ();

            var builder = new Builder ();
            builder.add_from_resource ("/com/mobilectpower/widgets/window.ui");
            builder.connect_signals (this);

            var box = builder.get_object ("box") as Box;
            add (box);

            headerbar = builder.get_object ("headerbar") as HeaderBar;
            button_back = builder.get_object ("button_back") as HeaderSimpleButton;

            stack = builder.get_object ("stack") as Stack;
            stack.headerbar = headerbar;

            notification = builder.get_object ("notification") as Notification;
            notification.add.connect (() => {
                notification.show ();
            });
            notification.remove.connect (() => {
                notification.dismiss ();
            });
        } catch (Error e) {
            error ("Failed to create widget: %s", e.message);
        }
    }

    [CCode (instance_pos = -1)]
    public void on_stack_add_remove (Container container,
                                     Widget widget) {
        var children = stack.get_children ();
        button_back.visible = children.length () > 1;
    }

    [CCode (instance_pos = -1)]
    public void on_button_back_clicked (Button button) {
        stack.pop ();
    }

}
