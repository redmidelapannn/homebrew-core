class Systemc < Formula
  desc "Core SystemC language and examples"
  homepage "https://accellera.org/"
  url "https://accellera.org/images/downloads/standards/systemc/systemc-2.3.3.zip"
  sha256 "fcdce4395a7d862fc891b4da9ced69c4a58f8670b56fafca0004cf4e72fdf7a1"

  bottle do
    cellar :any
    sha256 "0f0f318fe28ff80e126a788ea88047f1e04a172a510b41d0ab24805688667f82" => :mojave
    sha256 "13d3ae31e59662a00746fab65ae5cf802fac4e2785e0d3c1ab12639100deb89d" => :high_sierra
    sha256 "234969c0ce824b4aefa5582115a7ce3f24c160144ed55c7537dce2d4f40ab49f" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-arch-suffix=",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "systemc.h"

      int sc_main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lsystemc", "test.cpp"
    system "./a.out"
  end
end
