class Libvpx < Formula
  desc "VP8 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.6.0.tar.gz"
  sha256 "e2fc00c9f60c76f91a1cde16a2356e33a45b76a5a5a1370df65fd57052a4994a"
  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    rebuild 1
    sha256 "c95c7359d760f78ddf005216d7577f85b5d4c0948758552b0535121f57228d87" => :sierra
    sha256 "a74902c34141d5e79a944fd64f410e4bf880d43464258479f34e033f9f884172" => :el_capitan
    sha256 "54f56d3826fc4b6e45dd0fb885d1cb66446e1c64261c2354553283e376ee43b6" => :yosemite
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
    args << "--enable-vp9-highbitdepth"

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
