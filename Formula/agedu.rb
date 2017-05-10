class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20160920.853cea9.tar.gz"
  version "20160920"
  sha256 "9c52eefe4932a4c07a30a79dbf2089982443817002ab9eabb478063113df5e18"
  head "https://git.tartarus.org/simon/agedu.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1bf59a333d50e8cf95ed0fd44348f00f13bb7a7166a93bcb912e16999d65b0a8" => :sierra
    sha256 "85cfdb5e64433d4e1123c06eaedb859d5ca16c13a8fbd044a159db9ceac89651" => :el_capitan
    sha256 "f3b443001b947bebb9a675644ee34791998feabc7cc9b259e323300e22237527" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "halibut" => :build

  def install
    system "./mkauto.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"agedu", "-s", "."
    assert (testpath/"agedu.dat").exist?
  end
end
