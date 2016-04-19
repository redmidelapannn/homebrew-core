class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.20/gsettings-desktop-schemas-3.20.0.tar.xz"
  sha256 "55a41b533c0ab955e0a36a84d73829451c88b027d8d719955d8f695c35c6d9c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "092011db325353661a9f4c2473341e0202b3d634e03fc978ef7a53a9b3799c09" => :el_capitan
    sha256 "7917278eb4a79cc63e11e68aee8fa67cb559a853efa63dd5ed69ae588436f6e4" => :yosemite
    sha256 "7d58b83b94be992985dd643c4ce62c77b54be75f3bbe1372c731de031fa48bd9" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib"
  depends_on "gobject-introspection" => :build
  depends_on "gettext"
  depends_on "libffi"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile",
                          "--enable-introspection=yes"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gdesktop-enums.h>

      int main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/gsettings-desktop-schemas", "test.c", "-o", "test"
    system "./test"
  end

  def post_install
    # manual schema compile step
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end
end
