class Rund < Formula
  desc "Compiler-wrapper that runs and caches D programs"
  homepage "https://github.com/dragon-lang/rund"
  url "https://github.com/dragon-lang/rund/archive/v1.0.0.tar.gz"
  sha256 "25bc01e14f4a3c5151c3f79583e55a1b400b794bfebae460765b75b89ee217ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe2786c11d3f0d8557201eaa9340bcdb23503412acc3de61ed9d9516526c0ff2" => :catalina
    sha256 "c96245b5f20ea7fe22802a6f14950f3f76ee733ef210022837c288f480011957" => :mojave
    sha256 "c4158a9042b04bd3dfe234d4395ddd71b110add4eebfcf75ee725cc4b79e9302" => :high_sierra
  end

  depends_on "dmd"

  def install
    system "dmd", "-O", "-i", "-I=src", "-run", "make.d", "build"
    bin.install "./bin/rund"
  end

  test do
    (testpath/"test.d").write <<~EOS
      #!/usr/bin/env rund
      import std.stdio: writeln;
      int main() { return 0; }
    EOS
    File.chmod(0777, "test.d")
    system "./test.d"
  end
end
