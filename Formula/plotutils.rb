class Plotutils < Formula
  desc "C/C++ function library for exporting 2-D vector graphics"
  homepage "https://www.gnu.org/software/plotutils/"
  url "https://ftp.gnu.org/gnu/plotutils/plotutils-2.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/plotutils/plotutils-2.6.tar.gz"
  sha256 "4f4222820f97ca08c7ea707e4c53e5a3556af4d8f1ab51e0da6ff1627ff433ab"
  revision 1

  bottle do
    cellar :any
    rebuild 2
    sha256 "3fe2b2b5fab8bd6883000a94fa7ad17ee0ca248383b8f2bac36dd8fb5972f547" => :mojave
    sha256 "96365b7c06536ca0a9d6c80ffea3cae9d01d97495205a7200c699e90ffdd4b4b" => :high_sierra
    sha256 "54a8e96baea9caa8d238e8700439357f37ecb5023290023d5a0c94966c543572" => :sierra
  end

  depends_on "libpng"

  def install
    # Fix usage of libpng to be 1.5 compatible
    inreplace "libplot/z_write.c", "png_ptr->jmpbuf", "png_jmpbuf (png_ptr)"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-libplotter
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert pipe_output("#{bin}/graph -T ps", "0.0 0.0\n1.0 0.2\n").start_with?("")
  end
end
