class Systemc < Formula
  desc "Core SystemC language and examples"
  homepage "https://accellera.org/"
  url "https://accellera.org/images/downloads/standards/systemc/systemc-2.3.1.tgz"
  sha256 "7ce0f68fd4759e746a9808936b54e62d498f5b583e83fc47758ca86917b4f800"

  bottle do
    cellar :any
    rebuild 1
    sha256 "dc711ee0e53b9ee4c3aadadaaec38489aa347a21a73e0a4471454f82252c420e" => :sierra
    sha256 "eca918ca9eec3f1cbbae221f2b5ea15813eb39c8ed5757f7822115c6f3506bfc" => :el_capitan
    sha256 "9f9d8d245286b83941c4b5fc9ef8b339c37e8be6e1c71b40d7991b007d233a37" => :yosemite
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
    (testpath/"test.cpp").write <<-EOS.undent
      #include "systemc.h"

      int sc_main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lsystemc", "test.cpp"
    system "./a.out"
  end
end
