class Avian < Formula
  desc "Lightweight VM and class library for a subset of Java features"
  homepage "https://readytalk.github.io/avian/"
  url "https://github.com/ReadyTalk/avian/archive/v1.2.0.tar.gz"
  sha256 "e3639282962239ce09e4f79f327c679506d165810f08c92ce23e53e86e1d621c"
  head "https://github.com/ReadyTalk/avian.git"

  bottle do
    cellar :any
    sha256 "58a35339e25a7ee4d9382fac449c0f3d758580e82dbcb76c35ea69ef096c3f54" => :mojave
    sha256 "c516510686b29c46cbacb58aad1f72650dd4ca5da7fddbd9b47153314e7bbae2" => :high_sierra
    sha256 "986f0b8f02697f87a9424d60bd7f9fecc6a517e2dbf3c47d88e31a4a499b74ab" => :sierra
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
