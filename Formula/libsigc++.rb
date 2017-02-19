class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigc.sourceforge.io"
  url "https://download.gnome.org/sources/libsigc++/2.10/libsigc++-2.10.0.tar.xz"
  sha256 "f843d6346260bfcb4426259e314512b99e296e8ca241d771d21ac64f28298d81"

  bottle do
    cellar :any
    rebuild 1
    sha256 "12920c8f76f3e5cec1ac1dece67eb954c8ca6ef628962c04f157484a64ab9122" => :sierra
    sha256 "b5b17d7c727260e542cffe81d0792e44a5a7cf0992c476f388e0e764c818b17c" => :el_capitan
    sha256 "59571caee16ef59a6c6463d89dae9c386546f7e47e8db7605bd215b9802d0880" => :yosemite
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make", "check"
    system "make", "install"
  end
  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <sigc++/sigc++.h>

      void somefunction(int arg) {}

      int main(int argc, char *argv[])
      {
         sigc::slot<void, int> sl = sigc::ptr_fun(&somefunction);
         return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                   "-L#{lib}", "-lsigc-2.0", "-I#{include}/sigc++-2.0", "-I#{lib}/sigc++-2.0/include", "-o", "test"
    system "./test"
  end
end
