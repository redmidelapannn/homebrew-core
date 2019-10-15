class Vavrdiasm < Formula
  desc "8-bit Atmel AVR disassembler"
  homepage "https://github.com/vsergeev/vAVRdisasm"
  url "https://github.com/vsergeev/vavrdisasm/archive/v3.1.tar.gz"
  sha256 "4fe5edde40346cb08c280bd6d0399de7a8d2afdf20fb54bf41a8abb126636360"

  bottle do
    cellar :any_skip_relocation
    sha256 "eada6923268ecfe690323de3bafddda5d177cac56ba0f30cf426d015b5b9e538" => :catalina
    sha256 "5b0c0f8ae850c12118808020420ed94d9c7b221f1bb64ec81fe5553b089424e4" => :mojave
    sha256 "14295cb0db6aa3259a2b1e2c8ba020fee253804135aea259695ac00bdd906764" => :high_sierra
    sha256 "c04a9755b9f2e15fa512fdb08d28b95b8cf0304287f3a7930975b4ad75417fcf" => :sierra
    sha256 "0671b1062a86e8d596a9f404fd843cb37d6d2d1bb28ebb2b8a8f6cbdd763c97c" => :el_capitan
    sha256 "ce57062586ca9cb91290141376f1da1f5de3c6efb6fe4687585a3e64cc29c014" => :yosemite
    sha256 "f881c5a6d94581c4fc9efb13118c84c40700f13d130302f6ee4cb16968d1f6b0" => :mavericks
  end

  # Patch:
  # - BSD `install(1)' does not have a GNU-compatible `-D' (create intermediate
  #   directories) flag. Switch to using `mkdir -p'.
  # - Make `PREFIX' overridable
  #   https://github.com/vsergeev/vavrdisasm/pull/2
  patch :DATA

  def install
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    # Code to generate `file.hex':
    ## .device ATmega88
    ##
    ## LDI     R16, 0xfe
    ## SER     R17
    #
    # Compiled with avra:
    ## avra file.S && mv file.S.hex file.hex

    (testpath/"file.hex").write <<~EOS
      :020000020000FC
      :040000000EEF1FEFF1
      :00000001FF
    EOS

    output = `vavrdisasm file.hex`.lines.to_a

    assert output[0].match(/ldi\s+R16,\s0xfe/).length == 1
    assert output[1].match(/ser\s+R17/).length == 1
  end
end

__END__
diff --git a/Makefile b/Makefile
index 3b61942..f1c94fc 100644
--- a/Makefile
+++ b/Makefile
@@ -1,5 +1,5 @@
 PROGNAME = vavrdisasm
-PREFIX = /usr
+PREFIX ?= /usr
 BINDIR = $(PREFIX)/bin

 ################################################################################
@@ -35,7 +35,8 @@ test: $(PROGNAME)
 	python2 crazy_test.py

 install: $(PROGNAME)
-	install -D -s -m 0755 $(PROGNAME) $(DESTDIR)$(BINDIR)/$(PROGNAME)
+	mkdir -p $(DESTDIR)$(BINDIR)
+	install -s -m 0755 $(PROGNAME) $(DESTDIR)$(BINDIR)/$(PROGNAME)

 uninstall:
 	rm -f $(DESTDIR)$(BINDIR)/$(PROGNAME)
