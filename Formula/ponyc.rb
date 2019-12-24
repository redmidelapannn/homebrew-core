class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc/archive/0.33.1.tar.gz"
  sha256 "1c7e90e0779f153527dbbbdcd1e409a6d4e1a6ec627000798c1b22f1fcd44d4c"
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1d7f43603390929fcc77d8b1c54621c3b09906a02393a28a6c3bf53991bc909f" => :catalina
    sha256 "abc6d28e2baf6f236591cee19792f6461f0a9f50bd76dfb2567892b2a2857e5d" => :mojave
    sha256 "c306d0176b71d273f42ebfd11249899c5d3f0433806272c25245d325f31b5296" => :high_sierra
  end

  # https://github.com/ponylang/ponyc/issues/1274
  # https://github.com/Homebrew/homebrew-core/issues/5346
  pour_bottle? do
    reason <<~EOS
      The bottle requires Xcode/CLT 8.0 or later to work properly.
    EOS
    satisfy { DevelopmentTools.clang_build_version >= 800 }
  end

  depends_on "llvm@7"
  depends_on :macos => :yosemite

  def install
    ENV.cxx11
    ENV["LLVM_CONFIG"] = "#{Formula["llvm@7"].opt_bin}/llvm-config"
    system "make", "install", "verbose=1", "config=release", "arch=x86-64",
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
