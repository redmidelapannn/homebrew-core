class Libwandevent < Formula
  desc "API for developing event-driven programs"
  homepage "https://research.wand.net.nz/software/libwandevent.php"
  url "https://research.wand.net.nz/software/libwandevent/libwandevent-3.0.2.tar.gz"
  sha256 "48fa09918ff94f6249519118af735352e2119dc4f9b736c861ef35d59466644a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "dd4419f170548c61d21bc3bd3d36a92b1a2f6b0d3fbe39a045f0558460bb383d" => :sierra
    sha256 "8a9bda774f67292e3d844357565fe34f9812755ef4cbf5c6c9204f2d8b5c2417" => :el_capitan
    sha256 "88fa9cf21d2652f0daf531a375c502bb0173379b0168cb9ad632e86decdacb7a" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <sys/time.h>
      #include <libwandevent.h>

      int main() {
        wand_event_init();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lwandevent", "-o", "test"
    system "./test"
  end
end
