class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/VirusTotal/yara/"
  url "https://github.com/VirusTotal/yara/archive/v3.7.1.tar.gz"
  sha256 "df077a29b0fffbf4e7c575f838a440f42d09b215fcb3971e6fb6360318a64892"
  head "https://github.com/VirusTotal/yara.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "4d7014836a376a3664b4994f8a92a8d890b99326de8e6f1820f0082dfd208f01" => :high_sierra
    sha256 "703638826193241afde094c0abba3b0cfcf57187984b77a54f19a866af2cd063" => :sierra
    sha256 "94e657b1b446bd3e3d1ba1b1cf9ac965f64abbe75a52d5b4069c3b8ce723e698" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "python@2"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-dotnet"
    system "make", "install"
  end

  test do
    rules = testpath/"commodore.yara"
    rules.write <<~EOS
      rule chrout {
        meta:
          description = "Calls CBM KERNAL routine CHROUT"
        strings:
          $jsr_chrout = {20 D2 FF}
          $jmp_chrout = {4C D2 FF}
        condition:
          $jsr_chrout or $jmp_chrout
      }
    EOS

    program = testpath/"zero.prg"
    program.binwrite [0x00, 0xc0, 0xa9, 0x30, 0x4c, 0xd2, 0xff].pack("C*")

    assert_equal "chrout #{program}", shell_output("#{bin}/yara #{rules} #{program}").strip
  end
end
