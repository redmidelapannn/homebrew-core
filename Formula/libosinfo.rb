class Libosinfo < Formula
  desc "The Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.0.0.tar.gz"
  sha256 "f7b425ecde5197d200820eb44401c5033771a5d114bd6390230de768aad0396b"

  bottle do
    rebuild 1
    sha256 "578c49e306f0332e805b2c6d1e40cd96f669f3490041827867df084d54d986e9" => :sierra
    sha256 "e22d5a8e0f6124fb52bba2c58fc68ecf9bac0f8983c25a26a3a2a6ec9264651b" => :el_capitan
    sha256 "ac4bda9ba13d3eceb04a93f66fddfbc44474add4d8ce2d552902b3d34ff090ec" => :yosemite
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "wget" => :build

  depends_on "check"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "libxml2"
  depends_on "pygobject3"

  depends_on "gobject-introspection" => :recommended
  depends_on "vala" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --disable-silent-rules
      --disable-udev
      --enable-tests
    ]

    args << "--disable-introspection" if build.without? "gobject-introspection"
    if build.with? "vala"
      args << "--enable-vala"
    else
      args << "--disable-vala"
    end

    system "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.py").write <<-EOS.undent
      import gi
      gi.require_version('Libosinfo', '1.0')
      from gi.repository import Libosinfo as osinfo;

      loader = osinfo.Loader()
      loader.process_path("./")

      db = loader.get_db()

      devs = db.get_device_list()
      print "All device IDs"
      for dev in devs.get_elements():
        print ("  Device " + dev.get_id())

      names = db.unique_values_for_property_in_device("name")
      print "All device names"
      for name in names:
        print ("  Name " + name)

      osnames = db.unique_values_for_property_in_os("short-id")
      osnames.sort()
      print "All OS short IDs"
      for name in osnames:
        print ("  OS short id " + name)

      hvnames = db.unique_values_for_property_in_platform("short-id")
      hvnames.sort()
      print "All HV short IDs"
      for name in hvnames:
        print ("  HV short id " + name)
    EOS
    ENV.append_path "GI_TYPELIB_PATH", lib+"girepository-1.0"
    ENV.append_path "GI_TYPELIB_PATH", Formula["gobject-introspection"].opt_lib+"girepository-1.0"
    ENV.append_path "PYTHONPATH", lib+"python2.7/site-packages"
    ENV.append_path "PYTHONPATH", Formula["pygobject3"].opt_lib+"python2.7/site-packages"
    system "python", "test.py"
  end
end
