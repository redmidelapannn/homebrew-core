class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.13.0.tar.gz"
  sha256 "aa4273a221ad3a188f4d4d2753e6f78ad2640a3650f22f4ea610a0368df04eec"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a52e756372c3c41b87cacad1e9f4ff36f3577a6862436fdee043d9d1161d47e8" => :sierra
    sha256 "9c515fd38a9e9fbfc25799f52e403512356899e4ee3821f62edaf7aaa4e86c00" => :el_capitan
    sha256 "c3f3b84299863ae4a2147ab4d0de5b3f31fbe1341d6b506d37705f3ac10bcaa1" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on "llvm@3.9"
  depends_on "libressl"
  depends_on "pcre2"
  needs :cxx11

  # https://github.com/ponylang/ponyc/issues/1274
  # https://github.com/Homebrew/homebrew-core/issues/5346
  pour_bottle? do
    reason <<-EOS.undent
      The bottle requires Xcode/CLT 8.0 or later to work properly.
    EOS
    satisfy { DevelopmentTools.clang_build_version >= 800 }
  end

  def install
    ENV.cxx11
    ENV["LLVM_CONFIG"] = "#{Formula["llvm@3.9"].opt_bin}/llvm-config"
    system "make", "config=release", "destdir=#{prefix}", "install", "verbose=1"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<-EOS.undent
    actor Main
      new create(env: Env) =>
        env.out.print("Hello World!")
    EOS
    system "#{bin}/ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
