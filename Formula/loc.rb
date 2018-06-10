class Loc < Formula
  desc "Count lines of code quickly"
  homepage "https://github.com/cgag/loc"
  url "https://github.com/cgag/loc/archive/v0.4.1.tar.gz"
  sha256 "1e8403fd9a3832007f28fb389593cd6a572f719cd95d85619e7bbcf3dbea18e5"

  bottle do
    rebuild 1
    sha256 "9efd6a7a47034b64face6b2be8ae4c7e4a22f9557ca7319f07290dd1bdaf64b2" => :high_sierra
    sha256 "af0979fe1bf8dd425ef4dbd765b25525f7461e1cfe9abfdb6d4f4320ca38450d" => :sierra
    sha256 "355e37f1e0b0ef7c36481d7fe46a5a6b0401e7110df55d8ed34243a5e4b35f23" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdio.h>
      int main() {
        println("Hello World");
        return 0;
      }
    EOS
    system bin/"loc", "test.cpp"
  end
end
