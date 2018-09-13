class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.0.0/libjpeg-turbo-2.0.0.tar.gz"
  sha256 "778876105d0d316203c928fd2a0374c8c01f755d0a00b12a1c8934aeccff8868"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

  bottle do
    rebuild 1
    sha256 "2020347774b63cc3fb9ac236b4ffb9a159f205bb187ba936cd2b300fadaa0eec" => :mojave
    sha256 "a24c9385079886cc9e002fcd0ea0acc0137d55372e8ca4a63348194a34e3ceca" => :high_sierra
    sha256 "fee5429cc61d9f41876745b7cbb558b0ba12a53d1bd70e66eb4905ba4f186f7d" => :sierra
    sha256 "37be8e629c5e77d5ce2ca99d8f5824609ec9342428e9fba12f0d52af1ee650f7" => :el_capitan
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg"

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
    system "cmake", ".", "-DWITH_JPEG8=1", *std_cmake_args
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1", "-transpose", "-perfect",
                              "-outfile", "out.jpg", test_fixtures("test.jpg")
  end
end
