class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "a27e8160aca5d3aa5a6525b930da7edde44f8824dd4fba39aaef3b9af2717b74"
  revision 1

  bottle do
    sha256 "033609a42aa4a0475c9e99ded18595bf6ee9d5627f5ea2a33b90baae604c8483" => :sierra
    sha256 "23573727afa179069b8fa6fbc3cf46e5adbc1733c069fbc63b67e07dac9f9ae9" => :el_capitan
    sha256 "5eb6e328c9bb2b5b589e5f32b98c8d412e56c501a8a737d841a076a1f928c55e" => :yosemite
  end

  option "with-big-integer", "Use 64 bit precision instead of arbitrary precision for performance"
  option "with-ssl-verification", "Enable SSL peer certificate verification"

  depends_on :macos => :mavericks
  depends_on "cmake" => :build
  depends_on "flex"
  depends_on "icu4c"
  depends_on "xerces-c"

  conflicts_with "xqilla", :because => "Both supply xqc.h"

  needs :cxx11

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DZORBA_VERIFY_PEER_SSL_CERTIFICATE=ON" if build.with? "ssl-verification"
    args << "-DZORBA_WITH_BIG_INTEGER=ON" if build.with? "big-integer"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_equal shell_output("#{bin}/zorba -q 1+1").strip,
                 "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n2"
  end
end
