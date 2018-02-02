class Stm8flash < Formula
  desc "program your stm8 devices with SWIM/stlinkv(1,2)"
  homepage "https://github.com/vdudouyt/stm8flash"
  url "https://github.com/vdudouyt/stm8flash.git", :revision => "6007cb7062bb86d4c17c79174ee177e80939f602"
  version "20170616-1.1"
  bottle do
    cellar :any
    sha256 "602346cf8080d6b6214e680870bf40b11926287808bb5eb3b6360394816d29ee" => :high_sierra
    sha256 "47e737521fd980553f021b58f32fb933ab0fd63a3b2b1b2330338e15bd5e681a" => :sierra
    sha256 "011b12071ba9ebc54485c487c1e3351341b78381fb72e3ed9b9a676df02042f1" => :el_capitan
  end

  patch :DATA
  depends_on "libusb"
  depends_on "pkg-config" => :build
  def install
    system "make"
    system "make", "DESTDIR=#{prefix}", "install"
  end
  test do
    system "#{bin}/stm8flash", "-V"
  end
end
__END__
diff --git a/Makefile b/Makefile
index 7fc76c3..9cb8503 100644
--- a/Makefile
+++ b/Makefile
@@ -63,6 +63,6 @@ clean:
 	-rm -f $(OBJECTS) $(BIN)$(BIN_SUFFIX)

 install:
-	mkdir -p $(DESTDIR)/usr/local/bin/
-	cp $(BIN)$(BIN_SUFFIX) $(DESTDIR)/usr/local/bin/
+	mkdir -p $(DESTDIR)/bin/
+	cp $(BIN)$(BIN_SUFFIX) $(DESTDIR)/bin/
