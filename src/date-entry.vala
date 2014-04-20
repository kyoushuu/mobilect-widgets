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


[GtkTemplate (ui = "/com/mobilectpower/widgets/date-entry.ui")]
public class Mpcw.DateEntry : Box {

    [GtkChild]
    public Entry entry;
    [GtkChild]
    internal ToggleButton togglebutton;

    private Gtk.Window popup;

    internal void set_date (Date date) {
        char s[64];

        if (date.valid ()) {
            date.strftime (s, "%a, %d %b, %Y");
            entry.text = (string) s;
        }
    }

    internal Date get_date () {
        var date = Date ();
        date.set_parse (entry.text);

        return date;
    }

    [GtkCallback]
    public bool on_togglebutton_focus_out_event () {
        togglebutton.active = false;

        return false;
    }

    [GtkCallback]
    public void on_togglebutton_toggled () {
        if (togglebutton.active) {
            popup = new DateEntryPopup (this);
            popup.show ();
        } else if (popup != null) {
            popup.destroy ();
            popup = null;
        }
    }

    [GtkCallback]
    public bool on_entry_focus_out_event () {
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

        return false;
    }
}

[GtkTemplate (ui = "/com/mobilectpower/widgets/date-entry-popup.ui")]
public class Mpcw.DateEntryPopup : Gtk.Window {

    [GtkChild]
    private Calendar calendar;

    private DateEntry entry;

    private bool month_changed = true;

    public DateEntryPopup (DateEntry entry) {
        this.entry = entry;
    }

    construct {
        type = Gtk.WindowType.POPUP;
    }

    [GtkCallback]
    public void on_popup_show () {
        int x, y;
        Allocation button_alloc, popup_alloc;

        var window = entry.togglebutton.get_window ();
        var root_window = window.get_screen ().get_root_window ();
        window.get_origin (out x, out y);

        entry.togglebutton.get_allocation (out button_alloc);
        get_allocation (out popup_alloc);

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
        move (x, y);

        var date = entry.get_date ();
        if (date.valid ()) {
            month_changed = true;
            calendar.year = date.get_year ();
            month_changed = true;
            calendar.month = date.get_month () - 1;
            month_changed = true;
            calendar.day = date.get_day ();
        }
    }

    [GtkCallback]
    public void on_calendar_day_selected () {
        var date = Date ();
        date.set_dmy ((DateDay) calendar.day,
                      (DateMonth) calendar.month + 1,
                      (DateYear) calendar.year);
        entry.set_date (date);

        if (!month_changed) {
            entry.entry.grab_focus ();
        } else {
            month_changed = false;
        }
    }

    [GtkCallback]
    public void on_calendar_month_changed () {
        month_changed = true;
    }

}
