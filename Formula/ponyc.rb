class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.19.3.tar.gz"
  sha256 "1917fa434c34d82f9dd382ac74012fd2fcba4568a0b8d258e4ab1219a84983d8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b6e8a5ee77ed30d19c833eaac2121c397d9144c53bd40295ff48807549c9ad7e" => :high_sierra
    sha256 "872ae1fac4d65127058c28f6e03a16f9db3a319f99f1e32853a8f9836c443ddd" => :sierra
    sha256 "d8b0bfbb2def81f1c334834c78bcd9c64cd1ae0efecf1aaf3a73b2802d587c5c" => :el_capitan
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
    system "make", "config=release", "lto=no", "destdir=#{prefix}", "install", "verbose=1"
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
