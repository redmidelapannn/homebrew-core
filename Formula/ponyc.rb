class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.11.1.tar.gz"
  sha256 "5bac06a49940c7be74b8ff9798e39e57bea8d8b549c6dbe61bbf0067a117f50b"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "042d1a9708d32da5234b0b2a8e9dcbe740c1c3d4d52a3bbfc0971271dea2694d" => :sierra
    sha256 "7d6d892fc4c98bddcfe892dfb70fbe27581f33c09f074a01ba5becb3a8564387" => :el_capitan
    sha256 "7af8507dd6fee39cac374fb985fb0587efd003b3f416143e47dfffabba188152" => :yosemite
  end

  # Doesn't work with 4.0 yet and has a bug with 3.8
  # For 4.0 issue see https://github.com/ponylang/ponyc/issues/1592
  # For 3.8 issue see https://github.com/ponylang/ponyc/issues/1483#issuecomment-286739968
  depends_on "llvm@3.7"

  depends_on :macos => :yosemite
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
    ENV["LLVM_CONFIG"] = "#{Formula["llvm@3.7"].opt_bin}/llvm-config-3.7"
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
