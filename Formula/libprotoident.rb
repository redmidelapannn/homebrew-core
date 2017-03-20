class Libprotoident < Formula
  desc "Performs application layer protocol identification for flows"
  homepage "https://research.wand.net.nz/software/libprotoident.php"
  url "https://research.wand.net.nz/software/libprotoident/libprotoident-2.0.10.tar.gz"
  sha256 "a5ef504967c34fa07ed967b3a629a9df2768eb9da799858ceecd8026ca1efceb"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "84d665fb383d9463bba10cd31721cf24cde1af4fbbe39e2411f89004743bd103" => :sierra
    sha256 "0cf3e98ab3a22f3f44e5dc5c8bdf36cec6084533c54023a777afd12ac491b9f7" => :el_capitan
    sha256 "51bee673d1b4019b970ed2332bf68d6021c8dcd6b8bf187bca9e226cea356871" => :yosemite
  end

  depends_on "libtrace"
  depends_on "libflowmanager"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libprotoident.h>

      int main() {
        lpi_init_library();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lprotoident", "-o", "test"
    system "./test"
  end
end
