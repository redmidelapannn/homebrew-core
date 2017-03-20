class Httping < Formula
  desc "Ping-like tool for HTTP requests"
  homepage "https://www.vanheusden.com/httping/"
  url "https://www.vanheusden.com/httping/httping-2.5.tgz"
  sha256 "3e895a0a6d7bd79de25a255a1376d4da88eb09c34efdd0476ab5a907e75bfaf8"
  head "https://github.com/flok99/httping.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "203e4ee861bc322ed6f00cbe8ef7ca9ce272ae07ad36280cb11c705c9e9aa928" => :sierra
    sha256 "e25a66611886a2910aa8011dbe4fbb2c9d19cddd8c4590e030e02e2aabb4245c" => :el_capitan
    sha256 "e70e81eefb987a72075cb4008777749431b70995c8912f615491c2202d0adc83" => :yosemite
  end

  depends_on "gettext"
  depends_on "openssl"
  depends_on "fftw" => :optional

  def install
    # Reported upstream, see: https://github.com/Homebrew/homebrew/pull/28653
    inreplace %w[configure Makefile], "ncursesw", "ncurses"
    ENV.append "LDFLAGS", "-lintl"
    inreplace "Makefile", "cp nl.mo $(DESTDIR)/$(PREFIX)/share/locale/nl/LC_MESSAGES/httping.mo", ""
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    if MacOS.version >= :el_capitan
      system bin/"httping", "-c", "2", "-g", "https://brew.sh/"
    else
      system bin/"httping", "-c", "2", "-g", "http://brew.sh/"
    end
  end
end
