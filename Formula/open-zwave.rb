class OpenZwave < Formula
  desc "Library for selected Z-Wave PC controllers"
  homepage "http://www.openzwave.net/"
  url "https://github.com/OpenZWave/open-zwave/archive/v1.4.tar.gz"
  sha256 "efb54adf0cda12f76fcb478f7cf3b7d108b5daf38d60b4410cca7600aa072e83"
  head "https://github.com/OpenZWave/open-zwave.git"

  bottle do
    sha256 "4fe71346e683a085f43bfcb15bf3ca83d1f191db1559f9ec1b6041cc74a3bae1" => :high_sierra
    sha256 "ae461084330df47a702a7ded655d2b02f0efa9f1562854ff215da1133c49b5fa" => :sierra
    sha256 "ad9bcc26cb31716a419873e55aca51dda71e4589c7fd6573a74c74cb57ce25c1" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build

  def install
    ENV["BUILD"] = "release"
    ENV["PREFIX"] = prefix
    ENV["pkgconfigdir"] = "#{lib}/pkgconfig"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <openzwave/Manager.h>

      int main()
      {
        return OpenZWave::Manager::getVersionAsString().empty();
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/openzwave",
                    "-L#{lib}", "-lopenzwave", "-o", "test"
    system "./test"
  end
end
