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

    private HeaderBar _headerbar;
    public HeaderBar headerbar {
        public get {
            return _headerbar;
        }
        internal set {
            _headerbar = value;
            _headerbar.pack_start (button_back);
            update_back_button ();
        }
    }

    private bool _show_back_button = true;
    public bool show_back_button {
        public get {
            return _show_back_button;
        }
        internal set {
            _show_back_button = value;
            update_back_button ();
        }
    }

    private Button button_back;

    private weak StackPage current_page;

    construct {
        try {
            var builder = new Builder ();
            builder.add_from_resource ("/com/mobilectpower/widgets/stack.ui");
            builder.connect_signals (this);

            button_back = builder.get_object ("button_back") as Button;
        } catch (Error e) {
            error ("Failed to create widget: %s", e.message);
        }

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

    public Stack (HeaderBar headerbar) {
        this.headerbar = headerbar;
    }

    public void push (StackPage page, string? name = null, string? title = null) {
        page.stack = this;

        if (name != null && title != null) {
            add_titled (page, name, title);
        } else if (name != null) {
            add_named (page, name);
        } else {
            add (page);
        }
        update_back_button ();

        page.added ();
        set_visible_child (page);
    }

    public void pop () {
        var children = get_children ();
        if (children.length () >= 1) {
            var new_page = children.length () > 1 ?
                children.last ().prev.data as StackPage : null;
            var old_page = children.last ().data as StackPage;
            old_page.closed.connect ((page) => {
                headerbar.set_custom_title (null);
                if (new_page != null) {
                    set_visible_child (new_page);
                }
            });
            old_page.close ();
        }
    }

    public override void remove (Widget widget) {
        base.remove (widget);
        update_back_button ();
    }

    private void update_back_button () {
        var children = get_children ();
        button_back.visible = show_back_button && children.length () > 1;
    }

    [CCode (instance_pos = -1)]
    public void on_button_back_clicked (Button button) {
        pop ();
    }

}
