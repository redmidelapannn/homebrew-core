class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.33.2.tar.gz"
  sha256 "41ba573f16b4aecbcc39ec6d5b794185bf50e570b4a8f2cceef0a276e7fb50a3"
  head "https://github.com/ponylang/ponyc.git"
  revision 1

  bottle do
    cellar :any
    sha256 "351e76a4d30dbedb4d31a8cf7e0217943b0b9cb541713be3b946d7ed30512ce5" => :catalina
    sha256 "865424a59f5bab369a3db8f15ea38b94776fae4cbbbdf9b0e9f0feac6efcc674" => :mojave
    sha256 "9fbbbad8e8f0ffe5e51f94135c66a058ae5a0f9235bb52e59cae6032cb9bbdad" => :high_sierra
  end

  # https://github.com/ponylang/ponyc/issues/1274
  # https://github.com/Homebrew/homebrew-core/issues/5346
  pour_bottle? do
    reason <<~EOS
      The bottle requires Xcode/CLT 8.0 or later to work properly.
    EOS
    satisfy { DevelopmentTools.clang_build_version >= 800 }
  end

  depends_on "llvm@9"
  depends_on :macos => :yosemite

  def install
    ENV.cxx11
    ENV["LLVM_CONFIG"] = "#{Formula["llvm@9"].opt_bin}/llvm-config"
    system "make", "install", "verbose=1", "config=release",
           "ponydir=#{prefix}", "prefix="
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
