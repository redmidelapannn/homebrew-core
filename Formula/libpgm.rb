class Libpgm < Formula
  desc "Implements the PGM reliable multicast protocol"
  homepage "https://code.google.com/archive/p/openpgm/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/openpgm/libpgm-5.2.122~dfsg.tar.gz"
  version "5.2.122"
  sha256 "e296f714d7057e3cdb87f4e29b1aecb3b201b9fcb60aa19ed4eec29524f08bd8"

  bottle do
    cellar :any
    rebuild 2
    sha256 "51943c233d2e210757eda708740108cb406e3f707376f445cc0c99d777c325da" => :sierra
    sha256 "a500ec1b01b4a467bf572829e2c7f69f3b1a76a856bf5109d9c6702c87f63ed6" => :el_capitan
    sha256 "abbdbc77153106d07026ccc26f9858d27e0d55ae7e947b2ce05b7c18ba3863f4" => :yosemite
  end

  def install
    cd "openpgm/pgm" do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end
end
