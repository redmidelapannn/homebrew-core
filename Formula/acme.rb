class Acme < Formula
  desc "Crossassembler for multiple environments"
  homepage "https://sourceforge.net/projects/acme-crossass/"
  url "https://svn.code.sf.net/p/acme-crossass/code-0/trunk", :revision => "97"
  version "0.96.4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3a8fc78291cc1df234be0d9e14d6d19f3775b612bb1eed111e3ed77b5f0c5fc7" => :mojave
    sha256 "bce98073790cbcc0908caa303a40d3a1b71b926257f1058f6bcb171d9b406a18" => :high_sierra
    sha256 "4316fec53618bb93d6a00ac4ea4ee6c2c280006000157178011bf060f72834e2" => :sierra
  end

  def install
    system "make", "-C", "src", "install", "BINDIR=#{bin}"
    doc.install Dir["docs/*"]
  end

  test do
    path = testpath/"a.asm"
    path.write <<~EOS
      !to "a.out", cbm
      * = $c000
      jmp $fce2
    EOS

    system bin/"acme", path
    code = File.open(testpath/"a.out", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x00, 0xc0, 0x4c, 0xe2, 0xfc], code
  end
end
