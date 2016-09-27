class Vilistextum < Formula
  desc "HTML to text converter"
  homepage "http://bhaak.net/vilistextum/"
  url "http://bhaak.net/vilistextum/vilistextum-2.6.9.tar.gz"
  sha256 "3a16b4d70bfb144e044a8d584f091b0f9204d86a716997540190100c20aaf88d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b8fa6ddde71b9b86128e12bbc343935ca5ec58e15d28da2a1a9972a23df9becd" => :sierra
    sha256 "54fa55bce302c927bc7b473891ff622fca132f24f25ed5b4e06467acd02544b2" => :el_capitan
    sha256 "00e3c3535cc6a3e63f8417b4c89197b20eab2c8f61f05da6648d99e72be6cf05" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/vilistextum", "-v"
  end
end
