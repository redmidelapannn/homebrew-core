class Gputils < Formula
  desc "GNU PIC Utilities"
  homepage "http://gputils.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gputils/gputils/1.4.2/gputils-1.4.2-1.tar.gz"
  sha256 "e27b5c5ef3802a9c6c4a859d9ac2c380c31b3a2d6d6880718198bd1139b71271"

  bottle do
    revision 1
    sha256 "593b9557f9f55d051b0a8d74a49a8c79aad79a630dd0d0aacad07703c1340bdf" => :el_capitan
    sha256 "4e1918ade8be479bd017643b48db8cb12dfff108c1331eed33f134557d3bfc43" => :yosemite
    sha256 "4361ab40fd6816fe8f52aeec60492dd3f6e066391bb8fdf3dd6f9d70d0594dda" => :mavericks
  end

  devel do
    url "https://downloads.sourceforge.net/project/gputils/gputils/1.5.0/gputils-1.5.0_RC2.tar.bz2"
    version "1.5.0-rc2"
    sha256 "20301360e0e5a7e9c4cdbbb934f335731c8914f7f5a64a1395dfdaeb412d225e"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    # assemble with gpasm
    (testpath/"test.asm").write " movlw 0x42\n end\n"
    system "#{bin}/gpasm", "-p", "p16f84", "test.asm"
    assert File.exist?("test.hex")

    # disassemble with gpdasm
    output = shell_output("#{bin}/gpdasm -p p16f84 test.hex")
    assert_match "0000:  3042  movlw   0x42\n", output
  end
end
