class Advancemame < Formula
  desc "MAME with advanced video support"
  homepage "https://www.advancemame.it/"
  url "https://github.com/amadvance/advancemame/releases/download/v3.7/advancemame-3.7.tar.gz"
  sha256 "36c88305dc485e85ff86854b3d8bb75c4c81fa7356f6dbfcbfd6a5e192199b2c"

  bottle do
    rebuild 1
    sha256 "13729fe0e76da7806841475dea51ffec88b54c3370dd7b39da03a094b30aa781" => :high_sierra
    sha256 "d97cbc914092c301810a51465653ee89166116f5bdaf5d7acad8f2d04bf0722e" => :sierra
    sha256 "2467942feb836757b04e288f7eec0785cde917e0f0af69d755c6cf485de8cc98" => :el_capitan
  end

  depends_on "sdl"
  depends_on "freetype"

  conflicts_with "advancemenu", :because => "both install `advmenu` binaries"

  def install
    ENV.delete "SDKROOT" if MacOS.version == :yosemite
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "LDFLAGS=#{ENV.ldflags}", "mandir=#{man}", "docdir=#{doc}"
  end

  test do
    system "#{bin}/advmame", "--version"
  end
end
