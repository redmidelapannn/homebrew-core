class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.20.0.tar.gz"
  sha256 "f2be4b11714113eb506e1fcd4b7fdb6f6f84abc73291156a34b4e76abcb77866"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a2424381eee6bc2d305497d14eb92ba4bec7a0d4725316cea15b5ecbcc1d4adf" => :high_sierra
    sha256 "257f6b8a3170dce548da38ec994b098d33cce5e40132a0063eb688fd4ff23538" => :sierra
    sha256 "3ea85cc14fd82377e5eccb38b5d9b093e746d9898fedee92664c1d12d87f01c3" => :el_capitan
  end

  depends_on :macos => :yosemite
  depends_on "llvm@3.9"
  depends_on "libressl"
  depends_on "pcre2"
  needs :cxx11

  # https://github.com/ponylang/ponyc/issues/1274
  # https://github.com/Homebrew/homebrew-core/issues/5346
  pour_bottle? do
    reason <<~EOS
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

    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
