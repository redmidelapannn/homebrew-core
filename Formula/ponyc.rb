class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.12.0.tar.gz"
  sha256 "2cd1d51f696af30d72e6ac782ad87aad0bfdfdd0e9fef92ead340f756746e27f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4eae7f5b74c97227df8d057b50f99301d480564faac8d49b619f5913042bb4c6" => :sierra
    sha256 "c71ee66b3ccd60a352eb3e350c23db4b71ce5b814b2e82dc0cc47099743fd215" => :el_capitan
    sha256 "012815957ebf41cc8d9d1bc39c7914d38a8a21fa2d0ea1be66b27cff4ce0a4ce" => :yosemite
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
