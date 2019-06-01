class Weighttp < Formula
  desc "Webserver benchmarking tool that supports multithreading"
  homepage "https://redmine.lighttpd.net/projects/weighttp/wiki"
  url "https://github.com/lighttpd/weighttp/archive/weighttp-0.4.tar.gz"
  sha256 "b4954f2a1eca118260ffd503a8e3504dd32942e2e61d0fa18ccb6b8166594447"
  revision 1
  head "https://git.lighttpd.net/weighttp.git"

  bottle do
    cellar :any
    sha256 "3754c03249938305d816be7c6ba46f4614d261fa839f14ec97561a6e95a08f70" => :mojave
    sha256 "0d144acf52c7dc4b14b328429790c40a8162ee9f1f3262b12844a6033a5f819f" => :high_sierra
    sha256 "aa76b442700ac213d5ab68e79d947fc0ab3de4f32e200579e4166df64e842e7e" => :sierra
  end

  depends_on "libev"

  def install
    system "./waf", "configure"
    system "./waf", "build"
    bin.install "build/default/weighttp"
  end

  test do
    # Stick with HTTP to avoid 'error: no ssl support yet'
    system "#{bin}/weighttp", "-n", "1", "http://redmine.lighttpd.net/projects/weighttp/wiki"
  end
end
