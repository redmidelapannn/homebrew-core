class Gputils < Formula
  desc "GNU PIC Utilities"
  homepage "http://gputils.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gputils/gputils/1.4.2/gputils-1.4.2-1.tar.gz"
  sha256 "e27b5c5ef3802a9c6c4a859d9ac2c380c31b3a2d6d6880718198bd1139b71271"

  bottle do
    revision 1
    sha256 "344c74ceb1ca43d220881fa0fc69072e3f47cb2fb67b62551306c293cb4da057" => :el_capitan
    sha256 "7bdcf398b3db4c24c1f04f30c660fdd5334028ca71652e8d2e69a6e6670eeeab" => :yosemite
    sha256 "aa9bba1febef98df266d42677cd13bff4d5df745115b3b6ea093930606a9de60" => :mavericks
  end

  devel do
    url "https://downloads.sourceforge.net/project/gputils/gputils/1.5.0/gputils-1.5.0_RC5.tar.bz2"
    version "1.5.0-rc5"
    sha256 "793f4482a70e0e65b7152fa0183ed26ef7e8e19dff0205e5db7395b496ba1586"
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
