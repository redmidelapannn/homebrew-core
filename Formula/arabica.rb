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
    sha256 "0f336b38faa9035f2755394058aa3ecdff3a140dafdc8c5d8e7bb6c742ee8328" => :mojave
    sha256 "30707b8c2457bdc50b5697c7c60d873965058b1e79ce766f73213dc6943d8f90" => :high_sierra
    sha256 "5beeacc00b302d49a5229f1817fed784918e17edcbd1d4db61dd5b305f48626a" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  uses_from_macos "expat"

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
