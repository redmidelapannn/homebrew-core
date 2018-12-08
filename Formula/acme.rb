class Acme < Formula
  desc "Crossassembler for multiple environments"
  homepage "https://sourceforge.net/projects/acme-crossass/"
  url "https://svn.code.sf.net/p/acme-crossass/code-0/trunk", :revision => "97"
  version "0.96.4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7eaac3e3bd013a5e1739be4de8212d966bc641a9c1f2792e7bcae90545a9717f" => :high_sierra
    sha256 "3655203f7a262833988dd2e7089a24ee0f1d48728ef12ce07b0253de8589c33d" => :sierra
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
