class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.3.1.tar.gz"
  sha256 "1af638d69571776366cfcd4d0af4aa9913a4d83084b8949769290fa144a06a8c"

  bottle do
    cellar :any
    sha256 "35fc2b776671ac8a2e7b4f4614b6a22056a4e0178f8715a68acfe93bf97ffadb" => :el_capitan
    sha256 "eeaab96f56e204cb64455695217cf10a9848bbc33423ec86b06969b3a50903c7" => :yosemite
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
