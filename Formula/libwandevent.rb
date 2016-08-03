class Libwandevent < Formula
  desc "API for developing event-driven programs"
  homepage "http://research.wand.net.nz/software/libwandevent.php"
  url "http://research.wand.net.nz/software/libwandevent/libwandevent-3.0.1.tar.gz"
  sha256 "317b2cc39f912f8e5875b9dd05658cd48ead98bf20a1d89855e5a435381bee24"

  bottle do
    cellar :any
    revision 1
    sha256 "1ab266e3b3bc8071b38cd52f0542dd523465b12b17b661c6674554716470eced" => :el_capitan
    sha256 "0fe408af830b9cb0e9123f61ff3eafbe95a70894949b31823b4a3091ea73b892" => :yosemite
    sha256 "432486c4963c2e80818758a80dd4c176e611240d9f3fe8dcd58c5d8ac8ae6ccb" => :mavericks
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
