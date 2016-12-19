class Libvpx < Formula
  desc "VP8 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.6.0.tar.gz"
  sha256 "e2fc00c9f60c76f91a1cde16a2356e33a45b76a5a5a1370df65fd57052a4994a"
  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    rebuild 1
    sha256 "353f73b26f64c6c179fd7069897184f22d34c4bc86c6e37a3413a2473aaefe8b" => :sierra
    sha256 "915dcf54035bec54144c6f8b9451da930885736e5844e9cebb80f1396b420a2f" => :el_capitan
    sha256 "c893216dbf0d9de6ef3eaa6333f8b8286b2c70e7e0b8f1e031aa18c1493a4fb6" => :yosemite
  end

  option "with-gcov", "Enable code coverage"
  option "with-visualizer", "Enable post processing visualizer"
  option "with-examples", "Build examples (vpxdec/vpxenc)"

  deprecated_option "gcov" => "with-gcov"
  deprecated_option "visualizer" => "with-visualizer"

  depends_on "yasm" => :build

  # configure misdetects 32-bit 10.6
  # https://code.google.com/p/webm/issues/detail?id=401
  depends_on :macos => :lion

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

    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "otool", "-a", lib/"libvpx.a"
  end
end
