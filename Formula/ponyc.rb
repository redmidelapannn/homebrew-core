class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.3.1.tar.gz"
  sha256 "1af638d69571776366cfcd4d0af4aa9913a4d83084b8949769290fa144a06a8c"

  bottle do
    cellar :any
    sha256 "f6df5eb900bef459061d96c34cff43dbb13f28bd9dfa8ecfd2f5acdc8e0b3eae" => :el_capitan
    sha256 "86ceba344d3e12ab6af6ba3561429fc436a5e5979db4445ec9698901499da416" => :yosemite
  end

  depends_on "llvm"
  depends_on "libressl"
  depends_on "pcre2"
  needs :cxx11

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
