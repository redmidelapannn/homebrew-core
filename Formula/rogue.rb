class Rogue < Formula
  desc "Dungeon crawling video game"
  # Historical homepage: https://web.archive.org/web/20160604020207/rogue.rogueforge.net/
  homepage "https://sourceforge.net/projects/roguelike/"
  url "http://pkgs.fedoraproject.org/repo/pkgs/rogue/rogue5.4.4-src.tar.gz/033288f46444b06814c81ea69d96e075/rogue5.4.4-src.tar.gz"
  version "5.4.4"
  sha256 "7d37a61fc098bda0e6fac30799da347294067e8e079e4b40d6c781468e08e8a1"

  bottle do
    rebuild 1
    sha256 "596589fd4c86cf6e5f3de97c0ea0cefa898af846bbffbd97e682f953c087cce8" => :sierra
    sha256 "a67f9ce2277875a5f075044e150fe5adb954c7ea324ceecf2f8bb55e82ba1bba" => :el_capitan
    sha256 "8559144432f4c5552822fa92217d54136d1714ac53ee8b4a2e2846e54286c207" => :yosemite
  end

  def install
    ENV.ncurses_define if MacOS.version >= :snow_leopard

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    inreplace "config.h", "rogue.scr", "#{var}/rogue/rogue.scr"

    inreplace "Makefile" do |s|
      # Take out weird man install script and DIY below
      s.gsub! "-if test -d $(man6dir) ; then $(INSTALL) -m 0644 rogue.6 $(DESTDIR)$(man6dir)/$(PROGRAM).6 ; fi", ""
      s.gsub! "-if test ! -d $(man6dir) ; then $(INSTALL) -m 0644 rogue.6 $(DESTDIR)$(mandir)/$(PROGRAM).6 ; fi", ""
    end

    system "make", "install"
    man6.install gzip("rogue.6")
    libexec.mkpath
    (var/"rogue").mkpath
  end

  test do
    system "#{bin}/rogue", "-s"
  end
end
