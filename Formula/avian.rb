class Avian < Formula
  desc "Lightweight VM and class library for a subset of Java features"
  homepage "https://readytalk.github.io/avian/"
  url "https://github.com/ReadyTalk/avian/archive/v1.2.0.tar.gz"
  sha256 "e3639282962239ce09e4f79f327c679506d165810f08c92ce23e53e86e1d621c"
  head "https://github.com/ReadyTalk/avian.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "5fffdb3d8840396580ca33abbbe6af1c14a19e97372d9f1af8559f5425b96009" => :high_sierra
    sha256 "b4737d62570566f0e9d99ba2b2c04549c0f1372fac166b9fae7e1c0ceac998e0" => :sierra
    sha256 "db5dc8d6742bc840ad1fa817f16efbdef99298a5c51151dfd491403e7c66a4c5" => :el_capitan
  end

  depends_on :macos => :lion
  depends_on :java => "1.8"

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
