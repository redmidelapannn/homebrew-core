class Freexl < Formula
  desc "Library to extract data from Excel .xls files"
  homepage "https://www.gaia-gis.it/fossil/freexl/index"
  url "https://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-1.0.5.tar.gz"
  sha256 "3dc9b150d218b0e280a3d6a41d93c1e45f4d7155829d75f1e5bf3e0b0de6750d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ee892e7cbbf1593393a15367a51729b06dbaf42e5f32d703f085839d515ff7d2" => :high_sierra
    sha256 "2ff47abe40f110a3d68457b680e21feab08242e86207404556ba294265778dac" => :sierra
    sha256 "fcbcee4367a633b15be0ec4490943e5889941455016454d3da8ad72c28373cb5" => :el_capitan
  end

  option "without-test", "Skip compile-time make checks"

  deprecated_option "without-check" => "without-test"

  depends_on "doxygen" => [:optional, :build]

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"

    system "make", "check" if build.with? "test"
    system "make", "install"

    if build.with? "doxygen"
      system "doxygen"
      doc.install "html"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "freexl.h"

      int main()
      {
          printf(freexl_version());
          return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lfreexl", "test.c", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
