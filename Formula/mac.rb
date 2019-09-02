class Mac < Formula
  desc "Monkey's audio codec"
  homepage "https://www.monkeysaudio.com/"
  url "https://monkeysaudio.com/files/MAC_SDK_492.zip"
  version "4.92"
  sha256 "65170024af5c6518afdf31a3533131473a2fd29341626a315f21ce8d048ecf08"

  bottle do
    cellar :any
    sha256 "416dffca65600c06d58a9ebbafe1c32f6198fc0d1bda163b1b09517ac16c778c" => :mojave
    sha256 "079692ca459b58f40efda6e77b21f6b7f8543c6ab831362d5b04f7fd81452d71" => :high_sierra
    sha256 "d7fb7532aff66e0d97c1028b3a2ccf16f0d8105a9ecbca6a915918283e74eccd" => :sierra
  end

  patch :DATA

  def install
    system "make", "-f", "./Source/Projects/NonWindows/Makefile"
    system "make", "-f", "./Source/Projects/NonWindows/Makefile", "prefix=#{prefix}", "install"
  end

  test do
    system "#{bin}/mac", test_fixtures("test.wav"), "out.ape", "-c2000"
    system "#{bin}/mac", "out.ape", "out.wav", "-d"
  end
end


__END__
--- ./Source/Projects/NonWindows/Makefile.orig
+++ ./Source/Projects/NonWindows/Makefile
@@ -3,7 +3,7 @@
 
 VERSION	  = 5
 
-CXXOPTS	  = -I Shared -I Source/Shared -I Source/MACLib -c
+CXXOPTS	  = -I Source/Shared -I Source/MACLib -c
 LDOPTS	  = -lstdc++
 
 DLLLDOPTS = -shared
