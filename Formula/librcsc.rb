class Librcsc < Formula
  desc "RoboCup Soccer Simulator library"
  homepage "https://osdn.net/projects/rctools/"
  # Canonical: https://osdn.net/dl/rctools/librcsc-4.1.0.tar.gz
  url "https://dotsrc.dl.osdn.net/osdn/rctools/51941/librcsc-4.1.0.tar.gz"
  sha256 "1e8f66927b03fb921c5a2a8c763fb7297a4349c81d1411c450b180178b46f481"

  bottle do
    cellar :any
    rebuild 2
    sha256 "0c738c6aea55b6d83248c5c3d0e11af3f31ff3129feb01c4f5bf3e920e9cf457" => :el_capitan
  end

  depends_on "boost"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <rcsc/rcg.h>
      int main() {
        rcsc::rcg::PlayerT p;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lrcsc_rcg"
    system "./test"
  end
end
