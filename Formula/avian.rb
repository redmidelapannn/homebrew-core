class Avian < Formula
  desc "Lightweight VM and class library for a subset of Java features"
  homepage "https://readytalk.github.io/avian/"
  url "https://github.com/ReadyTalk/avian/archive/v1.2.0.tar.gz"
  sha256 "e3639282962239ce09e4f79f327c679506d165810f08c92ce23e53e86e1d621c"
  head "https://github.com/ReadyTalk/avian.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "c3d1bf1ccfbcfa2f8d79183ebc24d159ed2fedf6238edb5f32ed11eff90a1126" => :catalina
    sha256 "87176512df4d932e4d2c3bee65c9016a4dcd29e2a75df2ce698b3c8a85fc65fe" => :mojave
    sha256 "9ffd6d120920eb5f0c03b06e0cf511c81f6b270b5e38c29a2c12b0f029de9e10" => :high_sierra
  end

  depends_on :java => "1.8"
  uses_from_macos "zlib"

  def install
    system "make", "use-clang=true"
    bin.install Dir["build/macosx-*/avian*"]
    lib.install Dir["build/macosx-*/*.dylib", "build/macosx-*/*.a"]
  end

  test do
    (testpath/"Test.java").write <<~EOS
      public class Test {
        public static void main(String arg[]) {
          System.out.print("OK");
        }
      }
    EOS
    system "javac", "Test.java"
    assert_equal "OK", shell_output("#{bin}/avian Test")
  end
end
