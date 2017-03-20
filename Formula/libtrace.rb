class Libtrace < Formula
  desc "Library for trace processing supporting multiple inputs"
  homepage "https://research.wand.net.nz/software/libtrace.php"
  url "https://research.wand.net.nz/software/libtrace/libtrace-4.0.0.tar.bz2"
  sha256 "e89ac39808e2bb1e17e031191af8ab7bdbe3d2b0aeca4c6040e6fc8761ec0240"

  bottle do
    rebuild 1
    sha256 "eb7d33b598efca1525aeb38eb678246cddb095359418d7074b230c0a6463802a" => :sierra
    sha256 "285ae896235495733e47ab88d96cbd732122232eea305027ebbcdedb4629d760" => :el_capitan
    sha256 "6a7a7b4832d83cfe9f6eeafaa96eb3cf9d9e83f66ca9eb3022b55100cab2c1bd" => :yosemite
  end

  depends_on "openssl"
  depends_on "wandio"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
