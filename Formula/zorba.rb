class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "05eed935c0ff3626934a5a70724a42410fd93bc96aba1fa4821736210c7f1dd8"
  revision 10

  bottle do
    rebuild 1
    sha256 "3dd21cd0566e74222c22f721b4bf997a6aca9979f17091e67628bde8ac78c083" => :catalina
    sha256 "616926cb4c3b6c94f71243ac4172c19a9659aff168c6d3b6dd8b78807b2675ec" => :mojave
    sha256 "86c6cfd95e2f8ab75b56a007de17e565b67fb3107f187f3057d524373b4fc26a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "flex"
  depends_on "icu4c"
  depends_on "xerces-c"

  uses_from_macos "libxml2"

  conflicts_with "xqilla", :because => "Both supply xqc.h"

  def install
    # icu4c 61.1 compatability
    ENV.append "CXXFLAGS", "-DU_USING_ICU_NAMESPACE=1"

    ENV.cxx11

    args = std_cmake_args

    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # usual superenv fix doesn't work since zorba doesn't use HAVE_CLOCK_GETTIME
    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      args << "-DZORBA_HAVE_CLOCKGETTIME=OFF"
    end

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
