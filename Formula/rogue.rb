class Rogue < Formula
  desc "Dungeon crawling video game"
  homepage "https://web.archive.org/web/20160604020207/http://rogue.rogueforge.net/"
  url "http://pkgs.fedoraproject.org/repo/pkgs/rogue/rogue5.4.4-src.tar.gz/033288f46444b06814c81ea69d96e075/rogue5.4.4-src.tar.gz"
  version "5.4.4"
  sha256 "7d37a61fc098bda0e6fac30799da347294067e8e079e4b40d6c781468e08e8a1"

  bottle do
    rebuild 1
    sha256 "b12b6b9cccc1d6635a366f7ec3b632b0424254b951367fd06e96d2db44fa9c33" => :sierra
    sha256 "dc3a010d035723297806cccc63024fe916e7cca466f63382ee11abe46521baa2" => :el_capitan
    sha256 "e3e5ed60872f118e796368804dd73be8125a69239f728b746a695b14faad929d" => :yosemite
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
