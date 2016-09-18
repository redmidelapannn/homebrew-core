class Slrn < Formula
  desc "Powerful console-based newsreader"
  homepage "http://slrn.sourceforge.net/"
  url "http://jedsoft.org/releases/slrn/slrn-1.0.2.tar.bz2"
  sha256 "99acbc51e7212ccc5c39556fa8ec6ada772f0bb5cc45a3bb90dadb8fe764fb59"

  head "git://git.jedsoft.org/git/slrn.git"

  bottle do
    rebuild 1
    sha256 "0849e2b8757b322f0bac3d00faf5a677e1d61802f868b6e2fa40d80dac30a837" => :sierra
    sha256 "c336aa12892b3e9a44f8486609706d1c2a914c7f75eb1dcd3b8d4b4878a31b34" => :el_capitan
    sha256 "0de1f84ab4bbb4b3f3f7b8deac8a236a23c21ce04fac90b90304fe13a653cd00" => :yosemite
  end

  depends_on "s-lang"
  depends_on "openssl"

  def install
    bin.mkpath
    man1.mkpath
    mkdir_p "#{var}/spool/news/slrnpull"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--with-slrnpull=#{var}/spool/news/slrnpull",
                          "--with-slang=#{HOMEBREW_PREFIX}"
    system "make", "all", "slrnpull"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    assert_match version.to_s, shell_output("#{bin}/slrn --show-config")
  end
end
