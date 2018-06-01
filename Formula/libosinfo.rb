class Libosinfo < Formula
  desc "The Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.1.0.tar.gz"
  sha256 "600f43a4a8dae5086a01a3d44bcac2092b5fa1695121289806d544fb287d3136"
  revision 2

  bottle do
    sha256 "91bba50f47aadd5f46bb1914a00655c3e88bbce29895617e6a3bb9d36bfb5ec0" => :high_sierra
    sha256 "444f729ae672d278d156b0c5c99ca7e7b0c8d1fd10c5738f1690ddcc27311521" => :sierra
    sha256 "17a7cc35bea71fe36db7a7cda468ad30ac6aa3c9a6fc041e8a4ed269721a602f" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :optional
  depends_on "check"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libarchive" # for osinfo-db-tools
  depends_on "libsoup"
  depends_on "libxml2"

  resource "osinfo-db-tools" do
    url "https://releases.pagure.org/libosinfo/osinfo-db-tools-1.1.0.tar.gz"
    sha256 "a141cd2fc07c30d84801b5dbf6b11f2c2e708b0e81216277d052ac0b57fe546b"
  end

  resource "osinfo-db" do
    url "https://releases.pagure.org/libosinfo/osinfo-db-20180514.tar.xz", :using => :nounzip
    sha256 "4246b093c2903b349abb5e7f729ba83d36135b73cc3dc88882490fcb5f42dfdf"
  end

  def install
    # avoid wget dependency
    inreplace "Makefile.in", "wget -q -O", "curl -o"

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --disable-silent-rules
      --disable-udev
      --enable-tests
      --enable-introspection
    ]

    if build.with? "vala"
      args << "--enable-vala"
    else
      args << "--disable-vala"
    end

    system "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make", "install"

    resource("osinfo-db-tools").stage do
      system "./configure", "--prefix=#{prefix}",
                            "--localstatedir=#{var}",
                            "--sysconfdir=#{etc}",
                            "--disable-silent-rules"
      system "make", "install"
    end

    resource("osinfo-db").stage do |s|
      system "#{bin}/osinfo-db-import",
             "--system",
             "#{s.resource.name}-#{s.resource.version}.tar.xz"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <osinfo/osinfo.h>

      int main(int argc, char *argv[]) {
        OsinfoPlatformList *list = osinfo_platformlist_new();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libosinfo-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -losinfo-1.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    assert_match "#{share}/osinfo", shell_output("#{bin}/osinfo-db-path --system")
    system "#{bin}/osinfo-query", "os", "short-id=win10"
  end
end
