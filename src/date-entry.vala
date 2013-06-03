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


public class Mpcw.DateEntry : Bin {

    public Entry entry { public get; private set; }

    private Gtk.Window popup;
    private ToggleButton togglebutton;
    private Arrow arrow;
    private Calendar calendar;

    construct {
        try {
            var builder = new Builder ();
            builder.add_from_resource ("/com/mobilectpower/widgets/date-entry.ui");
            builder.connect_signals (this);

            var box = builder.get_object ("box") as Box;
            add (box);

            popup = builder.get_object ("popup") as Gtk.Window;
            entry = builder.get_object ("entry") as Entry;
            togglebutton = builder.get_object ("togglebutton") as ToggleButton;
            arrow = builder.get_object ("arrow") as Arrow;
            calendar = builder.get_object ("calendar") as Calendar;

            togglebutton.bind_property ("active", popup, "visible", 
                                        BindingFlags.BIDIRECTIONAL);
        } catch (Error e) {
            error ("Failed to create widget: %s", e.message);
        }
    }

    private void set_date (Date date) {
        char s[64];

        if (date.valid ()) {
            date.strftime (s, "%a, %d %b, %Y");
            entry.text = (string) s;
        }
    }

    private Date get_date () {
        var date = Date ();
        date.set_parse (entry.text);

        return date;
    }

    [CCode (instance_pos = -1)]
    public void on_togglebutton_focus_out_event (Widget widget,
                                                 Gdk.Event event) {
        popup.visible = false;
    }

    [CCode (instance_pos = -1)]
    public void on_entry_focus_out_event (Widget widget,
                                          Gdk.Event event) {
        var date = get_date ();

        if (date.valid ()) {
            DateYear year = date.get_year ();
            if (year >= 0 && year < 70) {
                year += 2000;
            } else if (year >= 70 && year < 100) {
                year += 1900;
            }
            date.set_year (year);

            set_date (date);
        }
    }

    [CCode (instance_pos = -1)]
    public void on_popup_show (Window popup) {
        int x, y;
        Allocation button_alloc, popup_alloc;

        var window = togglebutton.get_window ();
        var root_window = window.get_screen ().get_root_window ();
        window.get_origin (out x, out y);

        togglebutton.get_allocation (out button_alloc);
        popup.get_allocation (out popup_alloc);

        x += button_alloc.x;
        y += button_alloc.y;

        /* Make sure the popup will show up completely */
        if (x + button_alloc.width - popup_alloc.width >= 0) {
            x += button_alloc.width - popup_alloc.width;
        }
        if (y + button_alloc.height + popup_alloc.height <= root_window.get_height ()) {
            y += button_alloc.height;
        } else {
            y -= popup_alloc.height;
        }
        popup.move (x, y);

        var date = get_date ();
        if (date.valid ()) {
            calendar.year = date.get_year ();
            calendar.month = date.get_month () - 1;
            calendar.day = date.get_day ();
        }
    }

    [CCode (instance_pos = -1)]
    public void on_calendar_day_selected (Calendar widget) {
        var date = Date ();
        date.set_dmy ((DateDay) calendar.day,
                      (DateMonth) calendar.month + 1,
                      (DateYear) calendar.year);
        set_date (date);
    }

    [CCode (instance_pos = -1)]
    public void on_calendar_day_selected_double_click (Calendar widget) {
        popup.visible = false;
    }

}
