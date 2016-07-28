class OpenZwave < Formula
  desc "Library for selected Z-Wave PC controllers"
  homepage "http://www.openzwave.com"
  url "http://old.openzwave.com/downloads/openzwave-1.4.164.tar.gz"
  sha256 "4ecf39787aaf278c203764069b581dbc26094ce57cafeab4a0c1f012d2c0ac69"

  bottle do
    sha256 "ae0b9c6601f2316d67847eb7302330d421c1162f184004aa61e19d0a40c7c321" => :el_capitan
    sha256 "568656c6d967e0bbb0e0d783058fa5db6e5987d1fd295c4af90ebcb26d3e7446" => :yosemite
    sha256 "0aa245844089e9b144e8a2ae6dabb20fca411f7d07595abb8faa918672c4606c" => :mavericks
  end

  depends_on "pkg-config" => :build

  def install
    ENV["BUILD"] = "release"
    ENV["PREFIX"] = prefix

    # Make sure to set the correct install name otherwise the dylib would be incorrectly linked.
    # An issue was opened upstream: https://github.com/OpenZWave/open-zwave/issues/947
    inreplace "cpp/build/Makefile",
      "LDFLAGS += -dynamiclib",
      "LDFLAGS += -dynamiclib -install_name #{lib}/$(SHARED_LIB_NAME)"

    system "make", "install", "pkgconfigdir=#{lib}/pkgconfig", "sysconfdir=#{etc}/open-wave"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include "Options.h"
      int main() {
        OpenZWave::Options::Create("", "", "");
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "test", "-I", prefix/"include/openzwave", "-lopenzwave", "test.cpp"
    system "./test"
  end
end
