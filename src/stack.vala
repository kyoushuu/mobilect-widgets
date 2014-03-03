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

public class Mpcw.Stack : Gtk.Stack {

    public HeaderBar headerbar { public get; internal set; }

    private weak StackPage current_page;

    construct {
      notify["visible-child"].connect (() => {
          if (current_page != null) {
              current_page.hidden ();
          }
          if (visible_child != null) {
              current_page = visible_child as StackPage;
              current_page.shown ();
          }
      });
    }

    public void push (StackPage page) {
        page.stack = this;
        add (page);
        page.added ();
        set_visible_child (page);
    }

    public void pop () {
        var children = get_children ();
        if (children.length () > 1) {
            var new_page = children.last ().prev.data as StackPage;
            var old_page = children.last ().data as StackPage;
            old_page.closed.connect ((page) => {
                headerbar.set_custom_title (null);
                set_visible_child (new_page);
            });
            old_page.close ();
        }
    }

}
