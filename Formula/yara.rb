class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/plusvic/yara/"
  head "https://github.com/plusvic/yara.git"

  stable do
    url "https://github.com/plusvic/yara/archive/v3.4.0.tar.gz"
    sha256 "528571ff721364229f34f6d1ff0eedc3cd5a2a75bb94727dc6578c6efe3d618b"

    # fixes a variable redefinition error with clang (fixed in HEAD)
    patch do
      url "https://github.com/VirusTotal/yara/pull/261.diff"
      sha256 "6b5c135b577a71ca1c1a5f0a15e512f5157b13dfbd08710f9679fb4cd0b47dba"
    end
  end

  bottle do
    cellar :any
    revision 1
    sha256 "110a5a4fc48d60f4ac7d39d39d398edefac1d0ad64799b3837385372ba269f6d" => :el_capitan
    sha256 "6e23c0151ce14b066defa77c69e5e8765e83abb424e553bb7b18fe299d228997" => :yosemite
    sha256 "fa6f0c456c76443282be45161f82347559f990e79530228c634d381b4241cf63" => :mavericks
  end

  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pcre"
  depends_on "openssl"

  def install
    # Use of "inline" requires gnu89 semantics
    ENV.append "CFLAGS", "-std=gnu89" if ENV.compiler == :clang

    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{Formula["pcre"].opt_lib} -lpcre"

    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    cd "yara-python" do
      system "python", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    rules = testpath/"commodore.yara"
    rules.write <<-EOS.undent
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
