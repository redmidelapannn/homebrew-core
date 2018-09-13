class Arabica < Formula
  desc "XML toolkit written in C++"
  homepage "https://www.jezuk.co.uk/cgi-bin/view/arabica"
  url "https://github.com/jezhiggins/arabica/archive/2016-January.tar.gz"
  version "20160214"
  sha256 "addcbd13a6f814a8c692cff5d4d13491f0b12378d0ee45bdd6801aba21f9f2ae"
  head "https://github.com/jezhiggins/arabica.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "aefbce0108cec20902dc7e80ba1eaad05129fc837dc7f212ce64af10f61837dc" => :mojave
    sha256 "f304bf738fa0e2b09fd341c13be57bfbd404362548ce2b6cd3bc26019371b497" => :high_sierra
    sha256 "bf5e673a2e09f796de2de88b8878f58122baac54da47cc3c0d44808669e11eaf" => :sierra
    sha256 "63026cc1843e09ab44a3988d8032087b7cb6a5b7ba23b1223e84914263cbcf70" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mangle")
    assert_match "mangle is an (in-development) XSLT processor", output
  end
end
