class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "http://pocoproject.org/"
  url "http://pocoproject.org/releases/poco-1.7.2/poco-1.7.2-all.tar.gz"
  sha256 "926eaf5cb7c61ead0450b1cd9ec7a2c074a3e26620bffcb78e22ad3b2d9f0630"

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    revision 1
    sha256 "db7b78460ab863c9d5197d9dbcac76810c9a0deb14ef3643cfebc6f3a727b0dd" => :el_capitan
    sha256 "6d9511ca5d51411f749712061c1a949d91a2fcaa0070460cb1a27feb87cd0df4" => :yosemite
    sha256 "5f3d06744605cd36cf6ad7e604442a153216a5245ed004a4a781fb5193f1690c" => :mavericks
  end

  option :cxx11
  option :universal
  option "with-static", "Build static libraries (instead of shared)"

  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    ENV.cxx11 if build.cxx11?

    args = std_cmake_args
    args << "-DENABLE_DATA_MYSQL=OFF" << "-DENABLE_DATA_ODBC=OFF"

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    args << "-DPOCO_STATIC=ON" if build.with? "static"

    mkdir "macbuild" do
      system "cmake", buildpath, *args
      system "make", "install"
    end
  end

  test do
    system bin/"cpspc", "-h"
  end
end
