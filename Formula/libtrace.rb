class Libtrace < Formula
  desc "Library for trace processing supporting multiple inputs"
  homepage "http://research.wand.net.nz/software/libtrace.php"
  url "http://research.wand.net.nz/software/libtrace/libtrace-4.0.0.tar.bz2"
  sha256 "e89ac39808e2bb1e17e031191af8ab7bdbe3d2b0aeca4c6040e6fc8761ec0240"

  bottle do
    sha256 "e072e788c4fbd45d8df4e310131ba0d55daddead91f781764072b9dca8a05f32" => :el_capitan
  end

  depends_on "wandio"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
