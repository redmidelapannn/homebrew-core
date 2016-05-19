class Stress < Formula
  desc "Tool to impose load on and stress test a computer system"
  homepage "https://people.seas.harvard.edu/~apw/stress/"
  url "https://people.seas.harvard.edu/~apw/stress/stress-1.0.4.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/stress/stress_1.0.4.orig.tar.gz"
  sha256 "057e4fc2a7706411e1014bf172e4f94b63a12f18412378fca8684ca92408825b"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "b4635c185bfba65271d74aaff155161d2df388be303d135315066260e9699c5e" => :el_capitan
    sha256 "adc8dfe288f06e72d14c785af81a195cd7f7339aa90f783613a72bb593fb7b44" => :yosemite
    sha256 "97158b30cd9d3a66c28a8a76ce025d254258f8845d73be8c578c1a4a8212e71f" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"stress", "--cpu", "2", "--io", "1", "--vm", "1", "--vm-bytes", "128M", "--timeout", "1s", "--verbose"
  end
end
