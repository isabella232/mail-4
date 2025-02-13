// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/*-
 * Copyright (c) 2017 elementary LLC. (https://elementary.io)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: David Hewitt <davidmhewitt@gmail.com>
 */

public class Mail.ComposerWindow : Hdy.ApplicationWindow {

    public ComposerWidget composer_widget { get; construct; }

    public ComposerWindow (Gtk.Window parent, string? to = null, string? mailto_query = null) {
        Object (
            transient_for: parent,
            composer_widget: new ComposerWidget.with_headers (to, mailto_query)
        );
    }

    public ComposerWindow.for_widget (Gtk.Window parent, ComposerWidget composer_widget) {
        Object (
            transient_for: parent,
            composer_widget: composer_widget
        );
    }

    construct {
        var titlebar = new Hdy.HeaderBar () {
            has_subtitle = false,
            show_close_button = true,
            title = _("New Message")
        };
        titlebar.get_style_context ().add_class ("default-decoration");

        composer_widget.discarded.connect (() => {
            close ();
        });
        composer_widget.sent.connect (() => {
            close ();
        });
        composer_widget.subject_changed.connect ((subject) => {
            if (subject == null || subject.length == 0) {
                subject = _("New Message");
            }

            titlebar.title = title = subject;
        });

        var content_grid = new Gtk.Grid ();
        content_grid.orientation = Gtk.Orientation.VERTICAL;
        content_grid.add (titlebar);
        content_grid.add (composer_widget);

        height_request = 600;
        width_request = 680;
        title = _("New Message");
        window_position = Gtk.WindowPosition.CENTER_ON_PARENT;

        add (content_grid);
    }
}
