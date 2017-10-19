class Goocanvasmm < Formula
  desc "C++ wrappers for goocanvas"
  homepage "https://www.gtkmm.org"
  url "https://download.gnome.org/sources/goocanvasmm/1.90/goocanvasmm-1.90.11.tar.xz"
  sha256 "80ff11873ec0e73d9e38b0eb2ffb1586621f0b804093b990e49fdb546476ed6e"

  bottle do
    cellar :any
    sha256 "0b9233014a96b0ecc12a1d94d120e1f404e57e5529e17c4bc5c816aa7213b595" => :high_sierra
    sha256 "4a818e0d2b4257b4f711d3176b968c9339bd92f918b4c43d1386defde2c5730e" => :sierra
    sha256 "5322a7a475df566ba02b8e7a3b8bff121013bbae656bdeb005decaf78b69bbc9" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glibmm"
  depends_on "gtkmm3"
  depends_on "goocanvas"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<-EOS.undent
      #include <goocanvasmm.h>
      int main(int argc, char **argv) {
        Goocanvas::init();
      }
    EOS
    system ENV.cc, "-std=c++14", *shell_output("pkg-config --cflags --libs goocanvasmm-2.0").split, testpath/"test.cc", "-o", testpath/"test"
    system testpath/"test"
  end
end
