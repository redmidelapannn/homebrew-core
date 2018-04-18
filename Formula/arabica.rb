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
    sha256 "90728d545b8580984a1ba7cdd6fed208d0a5d00fd7277f69303c8a9e212949cd" => :high_sierra
    sha256 "f2c2c9e606252024285a4cf168e089c200cb409deb73c36af18ca530268a1097" => :sierra
    sha256 "86f86690c967b614ed1446a74b64e34e30d22b489d9d2ef0965bdedfdff10fc6" => :el_capitan
  end

  option "without-test", "Skip compile-time make checks (Not Recommended)"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost" => :recommended

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mangle")
    assert_match "mangle is an (in-development) XSLT processor", output
  end
end
