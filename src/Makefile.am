## Process this file with automake to produce Makefile.in

## Created by Anjuta

NULL =


AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	-I$(top_srcdir)/libgd \
	$(GTK_CFLAGS) \
	$(NULL)

AM_CFLAGS = \
	 -w \
	 -g

lib_LTLIBRARIES = libmobilect-widgets.la

libmobilect_widgets_la_SOURCES = \
	date-entry.vala \
	window.vala \
	stack.vala \
	stack-page.vala \
	view.vala \
	notification.vala \
	notification-item.vala \
	resources.c \
	$(NULL)

libmobilect_widgets_la_VALAFLAGS = \
	--vapidir=$(top_builddir)/libgd \
	--pkg=gtk+-3.0 \
	--pkg=gd-1.0 \
	--debug \
	--library mobilect-widgets-1.0 \
	-H mobilect-widgets.h \
	--vapi mobilect-widgets-1.0.vapi \
	$(NULL)

libmobilect_widgets_la_LDFLAGS = \
	-no-undefined \
	-version-info $(LT_VERSION_INFO) \
	$(NULL)

libmobilect_widgets_la_LIBADD = \
	$(GTK_LIBS) \
	$(top_builddir)/libgd/libgd.la \
	$(NULL)


mobilect_widgets_includedir = $(includedir)/mobilect-widgets-1.0
mobilect_widgets_include_HEADERS = \
	mobilect-widgets.h \
	$(NULL)


vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = \
	mobilect-widgets-1.0.vapi \
	mobilect-widgets-1.0.deps \
	$(NULL)


pkgconfigdir = $(libdir)/pkgconfig
dist_pkgconfig_DATA = \
	mobilect-widgets-1.0.pc \
	$(NULL)


resources = \
	date-entry.ui \
	window.ui \
	view.ui \
	notification-item.ui \
	$(NULL)

resources.c: mobilect-widgets.gresource.xml $(resources)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) \
		--sourcedir=$(srcdir) --target=$@ --generate $<


EXTRA_DIST = \
	mobilect-widgets.gresource.xml \
	$(resources) \
	$(NULL)
