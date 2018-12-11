class NodeAT6 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v6.15.1/node-v6.15.1.tar.xz"
  sha256 "c3bde58a904b5000a88fbad3de630d432693bc6d9d6fec60a5a19e68498129c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "de405ec39c81d302abaf379e47e1ac50724fbfa9c774d1abc11de1a9fef8a2d9" => :mojave
    sha256 "78c6f85cd711c2233dcdae9713b347097b9ae90175a4f4bc0fcc86de4f5d4531" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@2" => :build

  # Per upstream - "Need g++ 4.8 or clang++ 3.4".
  fails_with :clang if MacOS.version <= :snow_leopard
  fails_with :gcc_4_0
  fails_with :gcc_4_2
  ("4.3".."4.7").each do |n|
    fails_with :gcc => n
  end

  resource "icu4c" do
    url "https://ssl.icu-project.org/files/icu4c/58.2/icu4c-58_2-src.tgz"
    version "58.2"
    sha256 "2b0a4410153a9b20de0e20c7d8b66049a72aef244b53683d0d7521371683da0c"
  end

  def install
    # Switches standard libary for native addons from libstdc++ to libc++ to
    # match the superenv enforced one for the node binary itself. This fixes
    # incompatibilities between native addons built with our node-gyp and our
    # node binary and makes building native addons with XCode 10.1+ possible.
    inreplace "common.gypi", "'CLANG_CXX_LANGUAGE_STANDARD': 'gnu++0x',  # -std=gnu++0x",
                             "'CLANG_CXX_LANGUAGE_STANDARD': 'gnu++0x',  # -std=gnu++0x\n'CLANG_CXX_LIBRARY': 'libc++',"
    resource("icu4c").stage buildpath/"deps/icu"
    system "./configure", "--prefix=#{prefix}", "--with-intl=full-icu"
    system "make", "install"
  end

  def post_install
    (lib/"node_modules/npm/npmrc").atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output

    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"de-DE\").format(1234.56))'").strip
    assert_equal "1.234,56", output

    # make sure npm can find node
    ENV.prepend_path "PATH", opt_bin
    ENV.delete "NVM_NODEJS_ORG_MIRROR"
    assert_equal which("node"), opt_bin/"node"
    assert_predicate bin/"npm", :exist?, "npm must exist"
    assert_predicate bin/"npm", :executable?, "npm must be executable"
    npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
    system "#{bin}/npm", *npm_args, "install", "npm@latest"
    system "#{bin}/npm", *npm_args, "install", "bignum"
  end
end
