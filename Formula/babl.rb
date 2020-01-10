class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.72.tar.xz"
  sha256 "64e111097b1fa22f6c9bf044e341a9cd9ee1372c5acfa0b452e7a86fb37c6a42"
  # Use GitHub instead of GNOME's git. The latter is unreliable.
  head "https://github.com/GNOME/babl.git"

  bottle do
    sha256 "c9014b4ff7d1fe0e64955cbf46a101acfac4b0b5e2ba7996bf5539a53b077deb" => :catalina
    sha256 "daeb42fb349632f8f6ea0e8d5fb856c23fe13eb53b9bd04d0203722d2b25544c" => :mojave
    sha256 "31149b9b996ceea56be79f0e5eb6572363056c42dbcb67c7405ea1cdf163c45f" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "little-cms2"

  patch do
    url "https://gitlab.gnome.org/GNOME/babl/commit/a04535b0964d2bd40d08e4b3d16ff27b6ee7262c.diff"
    sha256 "8611e53e8d51207942ea54e8fc7a5773019ffd08ba188cead08fb18457e95789"
  end

  def install
    system "meson", "build", "--prefix=#{prefix}"
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <babl/babl.h>
      int main() {
        babl_init();
        const Babl *srgb = babl_format ("R'G'B' u8");
        const Babl *lab  = babl_format ("CIE Lab float");
        const Babl *rgb_to_lab_fish = babl_fish (srgb, lab);
        babl_exit();
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/babl-0.1", "-L#{lib}", "-lbabl-0.1", testpath/"test.c", "-o", "test"
    system testpath/"test"
  end
end
