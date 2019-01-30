class Dasm < Formula
  desc "Macro assembler with support for several 8-bit microprocessors"
  homepage "https://dasm-dillon.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dasm-dillon/dasm-dillon/2.20.11/dasm-2.20.11-2014.03.04-source.tar.gz"
  sha256 "a9330adae534aeffbfdb8b3ba838322b92e1e0bb24f24f05b0ffb0a656312f36"
  head "https://svn.code.sf.net/p/dasm-dillon/code/trunk"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "3df50392468f064e58c9041d85820d1bde13f29b3065267cff7f0dde32698938" => :mojave
    sha256 "3e5134d94969952d98f84a6d8d2407090f3ebbf0148466dd1ff5471bdc1b560c" => :high_sierra
    sha256 "5155acfa5153f874f005f03b9579e72ee3c4ac10153234769b0e9e4bf727c0e5" => :sierra
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
