class Kickassembler < Formula
  desc "Assembler for 6510 machine code and a high level script language"
  homepage "https://www.theweb.dk/KickAssembler/"
  url "https://www.theweb.dk/KickAssembler/KickAssembler.zip"
  version "4.19"
  bottle do
    cellar :any_skip_relocation
    sha256 "f587fd73db24869abd5db0f4e76b57ab6f2a88ece9b1411b707135fd767af58c" => :high_sierra
    sha256 "f587fd73db24869abd5db0f4e76b57ab6f2a88ece9b1411b707135fd767af58c" => :sierra
    sha256 "f587fd73db24869abd5db0f4e76b57ab6f2a88ece9b1411b707135fd767af58c" => :el_capitan
  end

  depends_on :java

  def install
    prefix.install Dir["Kick*", "Examples"]
  end

  def caveats; <<~EOS
    To assemble run:
      java -jar #{prefix}/KickAss.jar foo.asm
    EOS
  end

  test do
    (testpath/"foo.asm").write <<~EOS
      BasicUpstart2(start)
      start: inc $d020
             inc $d021
             jmp start
    EOS

    system "java", "-jar", "#{prefix}/KickAss.jar", "foo.asm"
    code = File.open("foo.prg", "rb") { |f| f.read.unpack("C*") }
    expected = [0x01, 0x08, 0x0b, 0x08, 0x0a, 0x00, 0x9e, 0x32,
                0x30, 0x36, 0x32, 0x00, 0x00, 0x00, 0x00, 0xee,
                0x20, 0xd0, 0xee, 0x21, 0xd0, 0x4c, 0x0e, 0x08]
    assert_equal expected, code
  end
end
