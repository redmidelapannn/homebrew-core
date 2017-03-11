class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "http://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "http://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20160920.853cea9.tar.gz"
  version "20160920"
  sha256 "9c52eefe4932a4c07a30a79dbf2089982443817002ab9eabb478063113df5e18"
  head "https://git.tartarus.org/simon/agedu.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a7389f328c5d133d98a8e19e45fe4e123f8693ba44fabf60bd9935d11996265c" => :sierra
    sha256 "098319c1a789ccd6fc54fdedea5a34a876d63585ce81dccccba9286cc27a327b" => :el_capitan
    sha256 "0a06feca4ed1585395c3a6209369e1562e8d28daacd5d5e669d7832679101f20" => :yosemite
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
