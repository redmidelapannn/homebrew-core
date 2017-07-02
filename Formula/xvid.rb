class Xvid < Formula
  desc "High-performance, high-quality MPEG-4 video library"
  homepage "https://www.xvid.com/"
  url "http://downloads.xvid.org/downloads/xvidcore-1.3.4.tar.gz"
  mirror "https://fossies.org/linux/misc/xvidcore-1.3.4.tar.gz"
  sha256 "4e9fd62728885855bc5007fe1be58df42e5e274497591fec37249e1052ae316f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7a5761e7e9f6da755ec5f29ff08b9ed80d5f2c95dedee7993f5415c37fa0198b" => :sierra
    sha256 "38af6e3c7a9296a49bdcfa9f1f4f0229da861ca401d51e6e8226771c70bc297a" => :el_capitan
    sha256 "170aaf42b6a669bdf325d859d22dccfe9b021224aa0c2ad702658b1ea62515ff" => :yosemite
  end

  def install
    cd "build/generic" do
      system "./configure", "--disable-assembly", "--prefix=#{prefix}"
      ENV.deparallelize # Or make fails
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <xvid.h>
      #define NULL 0
      int main() {
        xvid_gbl_init_t xvid_gbl_init;
        xvid_global(NULL, XVID_GBL_INIT, &xvid_gbl_init, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lxvidcore", "-o", "test"
    system "./test"
  end
end
