class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/bentley/rgbds"
  url "https://github.com/bentley/rgbds/releases/download/v0.2.4/rgbds-0.2.4.tar.gz"
  sha256 "a7d32f369c6acf65fc0875c72873ef21f4d3a5813d3a2ab74ea604429f7f0435"

  head "https://github.com/bentley/rgbds.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f5832136df58de24c972b8550ff2af8620b17624eb5eb430dd38f54549220892" => :sierra
    sha256 "543db6aadb6e403306a6262d36242291add007e063225b4a7ce3ff1dda1b7036" => :el_capitan
    sha256 "ff56a83c1428ad2ae662a79ec365a16c246d588f0e09f55dcdd692e62c9c76d5" => :yosemite
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
