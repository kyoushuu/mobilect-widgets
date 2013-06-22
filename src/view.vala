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

public class Mpcw.View : StackPage {

    public SelectionMode selection_mode { public get; public set; }
    public bool selection_mode_enabled { public get; public set; }

    private HeaderSimpleButton button_new;

    public virtual signal void new_activated () {
    }

    construct {
        try {
            var builder = new Builder ();
            builder.add_from_resource ("/com/mobilectpower/widgets/view.ui");
            builder.connect_signals (this);

            button_new = builder.get_object ("button_new") as HeaderSimpleButton;

            /* Hide/show new button when selection mode is enabled */
            bind_property ("selection-mode-enabled", button_new, "visible",
                           BindingFlags.SYNC_CREATE | BindingFlags.INVERT_BOOLEAN);
        } catch (Error e) {
            error ("Failed to create widget: %s", e.message);
        }
    }

    public override void added () {
        base.added ();
        if (stack.headerbar != null) {
            stack.headerbar.pack_start (button_new);
        }
    }

    public override void shown () {
        base.shown ();
        button_new.show ();
    }

    public override void hidden () {
        base.hidden ();
        button_new.hide ();
    }

    public override void closed () {
        base.closed ();
        button_new.destroy ();
    }

    [CCode (instance_pos = -1)]
    public void on_button_new_clicked (Button button) {
        new_activated ();
    }

}
