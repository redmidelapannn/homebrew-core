class Xvid < Formula
  desc "High-performance, high-quality MPEG-4 video library"
  homepage "https://www.xvid.com/"
  url "https://fossies.org/linux/misc/xvidcore-1.3.4.tar.gz"
  # Official download takes a long time to fail, so set it as the mirror for now
  mirror "http://downloads.xvid.org/downloads/xvidcore-1.3.4.tar.gz"
  sha256 "4e9fd62728885855bc5007fe1be58df42e5e274497591fec37249e1052ae316f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ff7464cad695483ed6575f06d3c0fdd4a571ef14234804522d80210f9d2c16cf" => :yosemite
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
