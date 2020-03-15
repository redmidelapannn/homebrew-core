class Httping < Formula
  desc "Ping-like tool for HTTP requests"
  homepage "https://www.vanheusden.com/httping/"
  url "https://www.vanheusden.com/httping/httping-2.5.tgz"
  sha256 "3e895a0a6d7bd79de25a255a1376d4da88eb09c34efdd0476ab5a907e75bfaf8"
  revision 2
  head "https://github.com/flok99/httping.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "730b4eba3bfe0cc7c7621d1cfecfcc4313eae18da2885504ed1f14cade425b03" => :catalina
    sha256 "2d56b47cc24d106b4160becd10afb464ce3ecddb08980cbeb82714cf846138da" => :mojave
    sha256 "66380e3e4bcc2038a7f56c179a46022e9a857e0ad91dd25db94ea6f6040ea1bd" => :high_sierra
  end

  depends_on "gettext"
  depends_on "openssl@1.1"

  def install
    # Reported upstream, see: https://github.com/Homebrew/homebrew/pull/28653
    inreplace %w[configure Makefile], "ncursesw", "ncurses"
    ENV.append "LDFLAGS", "-lintl"
    inreplace "Makefile", "cp nl.mo $(DESTDIR)/$(PREFIX)/share/locale/nl/LC_MESSAGES/httping.mo", ""
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"httping", "-c", "2", "-g", "https://brew.sh/"
  end
end
