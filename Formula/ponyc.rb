class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.4.0.tar.gz"
  sha256 "a2b5481df5e5ba3b2517e65027f69d83dd54c7e6cd5876508737d9ab7db42c3b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "85c6d990006ed9a72874a69f678d9e17f6d75cb7efad150e5aab8876b3869ebc" => :sierra
    sha256 "bf5bf63fd948e5842513779a5a87dfda8fd404276056c0cf1412da1dd5b478c1" => :el_capitan
    sha256 "c30bd63c11079789887d99a67b6bf46268a7e002cc04efbcee88db1e96d514ca" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on "llvm"
  depends_on "libressl"
  depends_on "pcre2"
  needs :cxx11

  # https://github.com/ponylang/ponyc/issues/1274
  # https://github.com/Homebrew/homebrew-core/issues/5346
  pour_bottle? do
    reason <<-EOS.undent
      The bottle requires Xcode/CLT 8.0 or later to work properly.
    EOS
    satisfy { DevelopmentTools.clang_build_version >= "800" }
  end

  def install
    ENV.cxx11
    ENV["LLVM_CONFIG"]="#{Formula["llvm"].opt_bin}/llvm-config"
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
