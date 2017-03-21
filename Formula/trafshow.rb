class Trafshow < Formula
  desc "Continuous network traffic display"
  # Upstream homepage down since late 2014, but only displays a manpage.
  homepage "https://web.archive.org/web/20130707021442/soft.risp.ru/trafshow/index_en.shtml"
  url "http://distcache.freebsd.org/ports-distfiles/trafshow-5.2.3.tgz"
  sha256 "ea7e22674a66afcc7174779d0f803c1f25b42271973b4f75fab293b8d7db11fc"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "5b3207ecfc1e826d095979f64c12c339a3f80eaa852c9cd142cbb36f88102d8f" => :sierra
    sha256 "d67d5906ee3264411efc2d33d6bee9ab61a08c45248e80279258783f06c7423b" => :el_capitan
    sha256 "f8a79d7577d78e85625babc2c71cadffd886e1a5df6e331f7ed66f06facdae4c" => :yosemite
  end

  depends_on "libtool" => :build

  {
    "domain_resolver.c" => "43b97d4ea025ed2087e4525a0b1acffc887082148df6dd2603b91fa70f79b678",
    "colormask.c"       => "04121b295d22a18aaf078611c75401a620570fbd89362bba2dd1abc042ea3c4a",
    "trafshow.c"        => "3164a612689d8ec310453a50fbb728f9bae3c356b88c41b6eab7ba7e925b1bf1",
    "trafshow.1"        => "8072e52acc56dd6f64c75f5d2e8a814431404b3fdfbc15149aaad1d469c47ff1",
    "configure"         => "c6e34dddd6c159cbd373b2b593f7643642cb10449c6bc6c606e160586bc5b794",
  }.each do |name, sha|
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/be6fd4a/trafshow/patch-#{name}"
      sha256 sha
    end
  end

  def install
    cp Dir["#{Formula["libtool"].opt_pkgshare}/*/config.{guess,sub}"], buildpath

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-slang"
    system "make"
    bin.install "trafshow"
    man1.install "trafshow.1"
    etc.install ".trafshow" => "trafshow.default"
  end
end
