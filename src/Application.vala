/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: Copyright 2014-2015 Atlas Developers, 2018-2022 Ryo Nakano
 */

public class Atlas.Application : Gtk.Application {
    private MainWindow window;
    public static Settings settings;

    public Application () {
        Object (
            flags: ApplicationFlags.FLAGS_NONE,
            application_id: Build.PROJECT_NAME
        );
    }

    construct {
        Intl.setlocale (LocaleCategory.ALL, "");
        Intl.bindtextdomain (Build.PROJECT_NAME, Build.LOCALEDIR);
        Intl.bind_textdomain_codeset (Build.PROJECT_NAME, "UTF-8");
        Intl.textdomain (Build.PROJECT_NAME);
    }

    static construct {
        settings = new Settings (Build.PROJECT_NAME);
    }

    protected override void activate () {
        if (get_windows () != null) {
            window.present ();
            return;
        }

        int x, y, w, h;
        x = Atlas.Application.settings.get_int ("position-x");
        y = Atlas.Application.settings.get_int ("position-y");
        w = Atlas.Application.settings.get_int ("window-width");
        h = Atlas.Application.settings.get_int ("window-height");

        window = new MainWindow (this);

        if (Atlas.Application.settings.get_boolean ("maximized")) {
            window.maximize ();
        } else if (x != -1 || y != -1) { // This is not the first time to launch
            window.move (x, y);
        } else { // This is the first time to launch
            window.window_position = Gtk.WindowPosition.CENTER;
        }

        window.set_default_size (w, h);
        window.show_all ();
    }

    public static int main (string[] args) {
        Clutter.init (ref args);
        var app = new Application ();
        return app.run (args);
    }
}
