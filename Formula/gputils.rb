class Gputils < Formula
  desc "GNU PIC Utilities"
  homepage "http://gputils.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gputils/gputils/1.4.2/gputils-1.4.2-1.tar.gz"
  sha256 "e27b5c5ef3802a9c6c4a859d9ac2c380c31b3a2d6d6880718198bd1139b71271"

  bottle do
    revision 1
    sha256 "a275f274e0c99451a23e0c8f96e7e82928a36ac2b47a022f2161f383847731b6" => :el_capitan
    sha256 "425f7e35c780d8861cb92ff25d70b312464f9c43ccc761fd35884074422b2758" => :yosemite
    sha256 "9a5dfe5cffd538813c4d4f251818fc259c1a53e9504dba0e9c7b04e4784f89d2" => :mavericks
  end

  devel do
    url "https://downloads.sourceforge.net/project/gputils/gputils/1.5.0/gputils-1.5.0_RC6.tar.bz2"
    version "1.5.0-rc6"
    sha256 "b4cda94b4b256bd51a45229da034b80950209d375f50308131378444f8f223a9"
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
