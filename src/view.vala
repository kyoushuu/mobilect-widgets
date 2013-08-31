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

    public enum ModelColumns {
        SELECTED,
        VISIBLE,
        NUM
    }

    public SelectionMode selection_mode { public get; public set; }
    public bool selection_mode_enabled { public get; public set; }
    public int selected_items_num { public get; private set; }

    private ListStore? _list;
    public ListStore? list {
        get {
            return _list;
        }
        set {
            if (value != null) {
                _list = value;
                filter = new TreeModelFilter (value, null);

                sort = new TreeModelSort.with_model (filter);
                treeview.model = sort;
            } else {
                _list = null;
                filter = null;
                sort = null;
                treeview.model = null;
            }

            selected_items_num = 0;
        }
    }

    public Overlay overlay;
    public TreeView treeview;
    public TreeViewColumn treeviewcolumn_selected;
    public TreeModelFilter filter;
    public TreeModelSort sort;

    private HeaderSimpleButton button_new;
    private HeaderToggleButton togglebutton_select;
    private HeaderToggleButton togglebutton_done;
    private Box box_select;

    public virtual signal void new_activated () {
    }

    public virtual signal void item_activated (TreeIter iter) {
    }

    construct {
        try {
            var builder = new Builder ();
            builder.add_from_resource ("/com/mobilectpower/widgets/view.ui");
            builder.connect_signals (this);

            var box = builder.get_object ("box") as Box;
            add (box);

            overlay = builder.get_object ("overlay") as Overlay;
            treeview = builder.get_object ("treeview") as TreeView;
            treeviewcolumn_selected = builder.get_object ("treeviewcolumn_selected") as TreeViewColumn;

            button_new = builder.get_object ("button_new") as HeaderSimpleButton;
            togglebutton_select = builder.get_object ("togglebutton_select") as HeaderToggleButton;
            togglebutton_done = builder.get_object ("togglebutton_done") as HeaderToggleButton;
            box_select = builder.get_object ("box_select") as Box;

            /* Hide/show new button when selection mode is enabled */
            bind_property ("selection-mode-enabled", button_new, "visible",
                           BindingFlags.SYNC_CREATE | BindingFlags.INVERT_BOOLEAN);

            /* Update selection mode when select button is toggled */
            togglebutton_select.bind_property ("active", this, "selection-mode-enabled",
                                               BindingFlags.SYNC_CREATE);

            /* Either select or done button is active */
            togglebutton_select.bind_property ("active", togglebutton_done, "active",
                                               BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE | BindingFlags.INVERT_BOOLEAN);

            /* Hide select and done buttons if they are active */
            togglebutton_select.bind_property ("active", togglebutton_select, "visible",
                                               BindingFlags.SYNC_CREATE | BindingFlags.INVERT_BOOLEAN);
            togglebutton_done.bind_property ("active", togglebutton_done, "visible",
                                             BindingFlags.SYNC_CREATE | BindingFlags.INVERT_BOOLEAN);

            /* Clear selection when selection mode is disabled */
            notify["selection-mode-enabled"].connect (() => {
                if (!selection_mode_enabled) {
                    select_none ();
                }
            });

            /* Show select column if select is active */
            bind_property ("selection-mode-enabled", treeviewcolumn_selected, "visible",
                           BindingFlags.SYNC_CREATE);
        } catch (Error e) {
            error ("Failed to create widget: %s", e.message);
        }
    }

    public override void added () {
        base.added ();
        if (stack.headerbar != null) {
            stack.headerbar.pack_start (button_new);
            stack.headerbar.pack_end (box_select);
        }
    }

    public override void shown () {
        base.shown ();
        button_new.show ();
        box_select.show ();
    }

    public override void hidden () {
        base.hidden ();
        button_new.hide ();
        box_select.hide ();
    }

    public override void closed () {
        base.closed ();
        button_new.destroy ();
        box_select.destroy ();
        stack.headerbar.get_style_context ().remove_class ("selection-mode");
    }

    public TreeIter[] get_selected_iters (bool selected = true) {
        var iters = new TreeIter[0];

        list.foreach ((model, path, iter) => {
            bool is_selected;

            list.get (iter, ModelColumns.SELECTED, out is_selected);

            if (selected == is_selected) {
                iters += iter;
            }

            return false;
        });

        return iters;
    }

    public void select_none () {
        if (list == null)
            return;

        foreach (var iter in get_selected_iters ()) {
            list.set (iter, ModelColumns.SELECTED, false);
            selected_items_num--;
        }
    }

    [CCode (instance_pos = -1)]
    public void on_button_new_clicked (Button button) {
        new_activated ();
    }

    [CCode (instance_pos = -1)]
    public void on_togglebutton_select_toggled (ToggleButton button) {
        if (togglebutton_select.active) {
            stack.headerbar.get_style_context ().add_class ("selection-mode");
        } else {
            stack.headerbar.get_style_context ().remove_class ("selection-mode");
        }
    }

    [CCode (instance_pos = -1)]
    public void on_treeview_row_activated (TreeView tree_view,
                                           TreePath path,
                                           TreeViewColumn column) {
        TreeIter sort_iter, filter_iter, iter;

        if (sort.get_iter (out sort_iter, path)) {
            sort.convert_iter_to_child_iter (out filter_iter, sort_iter);
            filter.convert_iter_to_child_iter (out iter, filter_iter);

            if (selection_mode_enabled) {
                bool selected;
                list.get (iter, ModelColumns.SELECTED, out selected);

                if (selected) {
                    selected_items_num--;
                } else {
                    selected_items_num++;
                }

                selected = !selected;
                list.set (iter, ModelColumns.SELECTED, selected);
            } else {
                item_activated (iter);
            }
        }
    }

}
