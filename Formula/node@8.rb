class NodeAT8 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v8.12.0/node-v8.12.0.tar.xz"
  sha256 "5a9dff58016c18fb4bf902d963b124ff058a550ebcd9840c677757387bce419a"

  bottle do
    rebuild 2
    sha256 "e16ccf19d577f00ad38d43d5b95482f915ebe1fe47443ee5ea7b4a0d6d3fee50" => :mojave
    sha256 "8f57115dbd3a8f6736dc052ed9a69abc7ca880543d7f5aa56915735247e74d9b" => :high_sierra
    sha256 "e5b7e76442e327fa60e09909ca14b7a2e518b1d0bcd20bd29537dc0f1b86f1e8" => :sierra
  end

  keg_only :versioned_formula

  option "with-openssl", "Build against Homebrew's OpenSSL instead of the bundled OpenSSL"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"
  option "without-icu4c", "Build with small-icu (English only) instead of system-icu (all locales)"

  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "icu4c" => :recommended
  depends_on "openssl" => :optional

  # Per upstream - "Need g++ 4.8 or clang++ 3.4".
  fails_with :clang if MacOS.version <= :snow_leopard
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.7").each do |n|
    fails_with :gcc => n
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--without-npm" if build.without? "npm"
    args << "--with-intl=system-icu" if build.with? "icu4c"
    args << "--shared-openssl" << "--openssl-use-def-ca-store" if build.with? "openssl"

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    return if build.without? "npm"
    (lib/"node_modules/npm/npmrc").atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  def caveats
    if build.without? "npm"
      <<~EOS
        Homebrew has NOT installed npm. If you later install it, you should supplement
        your NODE_PATH with the npm module folder:
          #{HOMEBREW_PREFIX}/lib/node_modules
      EOS
    end
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output
    if build.with? "icu4c"
      output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"de-DE\").format(1234.56))'").strip
      assert_equal "1.234,56", output
    end

    if build.with? "npm"
      # make sure npm can find node
      ENV.prepend_path "PATH", opt_bin
      ENV.delete "NVM_NODEJS_ORG_MIRROR"
      assert_equal which("node"), opt_bin/"node"
      assert_predicate bin/"npm", :exist?, "npm must exist"
      assert_predicate bin/"npm", :executable?, "npm must be executable"
      npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
      system "#{bin}/npm", *npm_args, "install", "npm@latest"
      system "#{bin}/npm", *npm_args, "install", "bignum"
      assert_predicate bin/"npx", :exist?, "npx must exist"
      assert_predicate bin/"npx", :executable?, "npx must be executable"
      assert_match "< hello >", shell_output("#{bin}/npx cowsay hello")
    end
  end
end
