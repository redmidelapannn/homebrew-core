class Xvid < Formula
  desc "High-performance, high-quality MPEG-4 video library"
  homepage "https://www.xvid.org"
  url "https://fossies.org/linux/misc/xvidcore-1.3.4.tar.gz"
  # Official download takes a long time to fail, so set it as the mirror for now
  mirror "http://downloads.xvid.org/downloads/xvidcore-1.3.4.tar.gz"
  sha256 "4e9fd62728885855bc5007fe1be58df42e5e274497591fec37249e1052ae316f"

  bottle do
    cellar :any
    revision 1
    sha256 "5576f4b22a9bcd74c8603fa458df4de403932ce6b6dc7117af3c17b770ab7448" => :el_capitan
    sha256 "d25b0ebc99c3fbfa49712eb3dbe929130e7a25a4c0d51f7f39d811244c557192" => :yosemite
    sha256 "006f4d844569b152503d41d24e5ff51ee6ffd6eab4f24043b896f72af1b9f62a" => :mavericks
  end

  def install
    cd "build/generic" do
      system "./configure", "--disable-assembly", "--prefix=#{prefix}"
      ENV.j1 # Or make fails
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
