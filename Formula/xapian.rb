class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.7/xapian-core-1.4.7.tar.xz"
  mirror "https://fossies.org/linux/www/xapian-core-1.4.7.tar.xz"
  sha256 "13f08a0b649c7afa804fa0e85678d693fd6069dd394c9b9e7d41973d74a3b5d3"

  bottle do
    cellar :any
    rebuild 2
    sha256 "e4581faff92db58dde7c348d92604999d675cd51c69fdbd3a4f13ef0f7831165" => :mojave
    sha256 "a326ccaba91a0b95abb04b64c08e1e06e8fca4daebacfa867ff82470fe1831d6" => :high_sierra
    sha256 "cfbe65900073b4e95b2d43502168fd13453f7b1efc8c488149ec7cffc96f6750" => :sierra
  end

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.7/xapian-bindings-1.4.7.tar.xz"
    sha256 "4519751376dc5b59893b812495e6004fd80eb4a10970829aede71a35264b4e6a"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"xapian-config", "--libs"
  end
end
