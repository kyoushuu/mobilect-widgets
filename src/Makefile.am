## Process this file with automake to produce Makefile.in

## Created by Anjuta

NULL =


AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(GTK_CFLAGS) \
	$(NULL)

AM_CFLAGS = \
	 -w \
	 -g

lib_LTLIBRARIES = libmobilect-widgets.la

libmobilect_widgets_la_SOURCES = \
	date-entry.vala \
	resources.c \
	$(NULL)

libmobilect_widgets_la_VALAFLAGS = \
	--pkg=gtk+-3.0 \
	--debug \
	--library mobilect-widgets-1.0 \
	$(NULL)

libmobilect_widgets_la_LDFLAGS = \
	-no-undefined \
	-version-info $(LT_VERSION_INFO) \
	$(NULL)

libmobilect_widgets_la_LIBADD = \
	$(GTK_LIBS) \
	$(NULL)


resources = \
	date-entry.ui \
	$(NULL)

resources.c: mobilect-widgets.gresource.xml $(resources)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) \
		--sourcedir=$(srcdir) --target=$@ --generate $<


EXTRA_DIST = \
	mobilect-widgets.gresource.xml \
	$(resources) \
	$(NULL)
