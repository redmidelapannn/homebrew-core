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
    sha256 "dc4291a97f58d3d77027fb17aa7936b1309f6a2734cb555cf527264af2f9d467" => :high_sierra
    sha256 "f7b68e77f9b6e34ba114126a74c9734089cafd8687fe4589e767314e6a415e76" => :sierra
    sha256 "01e935c00e82e4a957c14a67b2f598a86fccc5f5ee28786a28e92516468df5f6" => :el_capitan
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
end
