class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/releases/download/v0.2.4/rgbds-0.2.4.tar.gz"
  sha256 "a7d32f369c6acf65fc0875c72873ef21f4d3a5813d3a2ab74ea604429f7f0435"

  head "https://github.com/rednex/rgbds.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "64b10a1a4ee44432b1668eda8e7b975d2c1d2c155adbaf2e2256bd1b8dc429e9" => :sierra
    sha256 "971d891cdd47ae4f44f01adaac1c91623f37ae4b56e5c48dca506a1e3cdc0afb" => :el_capitan
    sha256 "bed3040cadbfc4efa25b015fbe8e15e557587dfda8ff42911b1130f672fc8f93" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libpng" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "PNGFLAGS=-I#{Formula["libpng"].opt_include}"
  end

  test do
    (testpath/"source.asm").write <<-EOS.undent
      SECTION "Org $100",HOME[$100]
      nop
      jp begin
      begin:
        ld sp, $ffff
        ld a, $1
        ld b, a
        add a, b
    EOS
    system "#{bin}/rgbasm", "source.asm"
  end
end
