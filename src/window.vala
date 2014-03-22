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

[GtkTemplate (ui = "/com/mobilectpower/widgets/window.ui")]
public class Mpcw.Window : ApplicationWindow {

    [GtkChild]
    public HeaderBar headerbar;
    [GtkChild]
    public Button button_back;
    [GtkChild]
    public Stack stack;

    construct {
        stack.headerbar = headerbar;
    }

    [GtkCallback]
    public void on_stack_add_remove (Widget widget) {
        var children = stack.get_children ();
        button_back.visible = children.length () > 1;
    }

    [GtkCallback]
    public void on_button_back_clicked () {
        stack.pop ();
    }

}
