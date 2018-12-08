class Dasm < Formula
  desc "Macro assembler with support for several 8-bit microprocessors"
  homepage "https://dasm-dillon.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dasm-dillon/dasm-dillon/2.20.11/dasm-2.20.11-2014.03.04-source.tar.gz"
  sha256 "a9330adae534aeffbfdb8b3ba838322b92e1e0bb24f24f05b0ffb0a656312f36"
  head "https://svn.code.sf.net/p/dasm-dillon/code/trunk"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "baaa8ee01aa505ee6dc784a8cffbe41a50b00f5acdac43e7901fb214d89ea6b6" => :mojave
    sha256 "5ce97aae233e978710d84d7cff73ea72a4833b30b417e873989ace639c3272bd" => :high_sierra
    sha256 "47e184b46ac5b41c1ebc4ed82b4486343b2671aa6813236eb56b0fdea91b018c" => :sierra
  end

  def install
    system "make"
    prefix.install "bin", "doc"
  end

  test do
    path = testpath/"a.asm"
    path.write <<~EOS
      ; Instructions must be preceded by whitespace
        processor 6502
        org $c000
        jmp $fce2
    EOS

    system bin/"dasm", path
    code = (testpath/"a.out").binread.unpack("C*")
    assert_equal [0x00, 0xc0, 0x4c, 0xe2, 0xfc], code
  end
end
