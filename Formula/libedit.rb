class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20170329-3.1.tar.gz"
  version "20170329-3.1"
  sha256 "91f2d90fbd2a048ff6dad7131d9a39e690fd8a8fd982a353f1333dd4017dd4be"

  bottle do
    cellar :any
    rebuild 1
    sha256 "011b034d8dffbb64134c988ee3a98011b9b60f32ba34b0369479cefb208c2a5e" => :high_sierra
    sha256 "739d831c97b647f8bb8ae9e39540653bfb43e90f191b6b9bc9fcf7535e4be90b" => :sierra
    sha256 "2dbaf680d9d68b46d4da597914d22ab47334d4f78599ff80553b356320538f17" => :el_capitan
  end

  keg_only :provided_by_osx

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end
