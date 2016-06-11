class Surfraw < Formula
  desc "Shell Users' Revolutionary Front Rage Against the Web"
  homepage "https://surfraw.alioth.debian.org/"
  url "https://surfraw.alioth.debian.org/dist/surfraw-2.2.9.tar.gz"
  sha256 "aa97d9ac24ca4299be39fcde562b98ed556b3bf5ee9a1ae497e0ce040bbcc4bb"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "1347e3ba2810c9292b5479a082892fcd27b0891707d45aad46b873f7814e1b86" => :el_capitan
    sha256 "3cd3bc8e2c03f03547c380052600f22380d4c1e05fdd3e13951052e052961e00" => :yosemite
    sha256 "5c0b00055cb42ce09c67a5eee6070427beca86409ffe40bb90134e6ff3ae6e1a" => :mavericks
  end

  head do
    url "https://anonscm.debian.org/git/surfraw/surfraw.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./prebuild" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-graphical-browser=open"
    system "make"
    ENV.j1
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/surfraw -p duckduckgo homebrew")
    assert_equal "https://www.duckduckgo.com/lite/?q=homebrew\n", output
  end
end
