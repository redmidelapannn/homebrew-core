class Libvpx < Formula
  desc "VP8 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.5.0.tar.gz"
  sha256 "f199b03b67042e8d94a3ae8bc841fb82b6a8430bdf3965aeeaafe8245bcfa699"
  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    revision 1
    sha256 "492f19298d2bcf6473594611d2d44945c9bf51cf6f10fbacaa6fdc43f6dce27a" => :el_capitan
    sha256 "2fe283cd8827c3ad24ad2ba300d2929a121035fd0dc35850fb59641b89a0473d" => :yosemite
    sha256 "4c029268c660e6be7453535597f6045e9a012b1e8ad0d19f9363dfc899c38b6b" => :mavericks
  end

  option "with-gcov", "Enable code coverage"
  option "with-visualizer", "Enable post processing visualizer"
  option "with-examples", "Build examples (vpxdec/vpxenc)"

  deprecated_option "gcov" => "with-gcov"
  deprecated_option "visualizer" => "with-visualizer"

  depends_on "yasm" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-pic
      --disable-unit-tests
    ]

    args << (build.with?("examples") ? "--enable-examples" : "--disable-examples")
    args << "--enable-gcov" if !ENV.compiler == :clang && build.with?("gcov")
    args << "--enable-postproc" << "--enable-postproc-visualizer" if build.with? "visualizer"

    # configure misdetects 32-bit 10.6
    # https://code.google.com/p/webm/issues/detail?id=401
    if MacOS.version == "10.6" && Hardware::CPU.is_32_bit?
      args << "--target=x86-darwin10-gcc"
    end

    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end
end
