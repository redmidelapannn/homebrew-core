class Libident < Formula
  desc "Ident protocol library"
  homepage "https://www.remlab.net/libident/"
  url "https://www.remlab.net/files/libident/libident-0.32.tar.gz"
  sha256 "8cc8fb69f1c888be7cffde7f4caeb3dc6cd0abbc475337683a720aa7638a174b"

  bottle do
    cellar :any
    rebuild 2
    sha256 "4bea5aacca509d92412687b82375ca286f327c6e0a59cc5590929e8d4f227910" => :sierra
    sha256 "8e35b300ef94249f6b5ab5c4b627533e025d259c96d8c27870c79836bc811cfe" => :el_capitan
    sha256 "fbf02f2fc744338eaaae12f96112e9242a48c5a72ca8fd794f4172ebdf69147e" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
