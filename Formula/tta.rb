class Tta < Formula
  desc "Lossless audio codec"
  homepage "http://tta.tausoft.org/"
  url "https://downloads.sourceforge.net/project/tta/tta/libtta/libtta-c-2.3.tar.gz"
  sha256 "68ba6db2d494dcd4aa6832a40952b88a3d50ca1174ab0ef1e091db16992303c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "49c5d7da49b7c44175492d5b4be675ddf0b803407e83f58edf0b275fab14778a" => :catalina
    sha256 "69971bac36ccee5c9ea40ad2f87a58c347a827ee8fc3d938ece9a43452f86306" => :mojave
    sha256 "4837fe0bb31f948f034928e9dcf39c6bd393e45424987595a52f7081c466e710" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-sse4"
    system "make", "install"
  end
end
