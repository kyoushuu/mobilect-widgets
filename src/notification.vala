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

public class Mpcw.Notification : Gd.Notification {

    private List<Widget> queue;
    private Box box;

    construct {
        try {
            Gd.ensure_types ();

            var builder = new Builder ();
            builder.add_from_resource ("/com/mobilectpower/widgets/notification-item.ui");
            builder.connect_signals (this);

            box = builder.get_object ("box") as Box;
            add (box);
        } catch (Error e) {
            error ("Failed to create widget: %s", e.message);
        }
    }

    public void box_remove (Container container, Widget widget) {
        ulong handler = 0;

/*        handler = dismissed.connect_after (() => {
            stdout.printf ("remove\n");
            base.remove (widget);
            stdout.printf ("removed\n");
            disconnect (handler);
        });
*/

        queue.append (widget);
        Timeout.add_seconds (1, () => {
            queue.remove (widget);

            return false;
        });

        if (box.get_children ().length () <= 1) {
            dismiss ();
        }
    }

}
