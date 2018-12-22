class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.0.1/libjpeg-turbo-2.0.1.tar.gz"
  sha256 "e5f86cec31df1d39596e0cca619ab1b01f99025a27dafdfc97a30f3a12f866ff"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

  bottle do
    cellar :any
    sha256 "3a8cd04261a22cccc66f20a70bf8325fd156ce333383c72584e64e16c42df3b2" => :mojave
    sha256 "b6b46224d47d85627453c39205f10ca1728a1986e5989c65bf3a1d6bea21b400" => :high_sierra
    sha256 "9107f3e46ab1895d45ee2b0229d9fafa316320a1c48ebadb7ba3bfed54c24f1b" => :sierra
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
