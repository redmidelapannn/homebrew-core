class Ftimes < Formula
  desc "System baselining and evidence collection tool"
  homepage "https://ftimes.sourceforge.io/FTimes/index.shtml"
  url "https://downloads.sourceforge.net/project/ftimes/ftimes/3.11.0/ftimes-3.11.0.tgz"
  sha256 "70178e80c4ea7a8ce65404dd85a4bf5958a78f6a60c48f1fd06f78741c200f64"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "e4b55d1a1dc499dd186548139f535289f16422726207d1dab002cb8009574dd6" => :mojave
    sha256 "0a4461b7da1e50d463dd9d7cfa53443dc7ad90dcae1c26a9455b9dd86f2e663b" => :high_sierra
    sha256 "fbdbc181b6f1421ed9091a10b279d1d09d4ff8218525acfd25eba0c373139b5c" => :sierra
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-pcre=#{Formula["pcre"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-server-prefix=#{var}/ftimes"

    inreplace "doc/ftimes/Makefile" do |s|
      s.change_make_var! "INSTALL_PREFIX", man1
    end

    system "make", "install"
  end

  test do
    assert_match /ftimes #{version}/, shell_output("#{bin}/ftimes --version")
  end
end
