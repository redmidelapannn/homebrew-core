class NodeAT6 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v6.14.4/node-v6.14.4.tar.xz"
  sha256 "9a4bfc99787f8bdb07d5ae8b1f00ec3757e7b09c99d11f0e8a5e9a16a134ec0f"

  bottle do
    rebuild 1
    sha256 "fa3117d073c80a486e7c4f6aa666223bd2e53ecc4189f0a4ac342ecc7b4160d9" => :mojave
    sha256 "51f46d6acafa59b64645b6c55f711e748c0866312e1da86789e501a5d417cc51" => :high_sierra
    sha256 "162182b5ed2f23717b30ab934598557f4970d629762a886a09fd90b6a3877cd3" => :sierra
  end

  keg_only :versioned_formula

  option "with-openssl", "Build against Homebrew's OpenSSL instead of the bundled OpenSSL"
  option "without-npm", "npm will not be installed"
  option "with-full-icu", "Build with full-icu (all locales) instead of small-icu (English only)"

  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "openssl" => :optional

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
    args = ["--prefix=#{prefix}"]
    args << "--without-npm" if build.without? "npm"
    args << "--shared-openssl" << "--openssl-use-def-ca-store" if build.with? "openssl"

    if build.with? "full-icu"
      resource("icu4c").stage buildpath/"deps/icu"
      args << "--with-intl=full-icu"
    end

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    return if build.without? "npm"
    (lib/"node_modules/npm/npmrc").atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  def caveats
    s = ""

    if build.without? "npm"
      s += <<~EOS
        Homebrew has NOT installed npm. If you later install it, you should supplement
        your NODE_PATH with the npm module folder:
          #{HOMEBREW_PREFIX}/lib/node_modules
      EOS
    end

    if build.without? "full-icu"
      s += <<~EOS
        Please note by default only English locale support is provided. If you need
        full locale support you should either rebuild with full icu:
          `brew reinstall node --with-full-icu`
        or add full icu data at runtime following:
          https://github.com/nodejs/node/wiki/Intl#using-and-customizing-the-small-icu-build
      EOS
    end

    s
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output
    if build.with? "full-icu"
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
    end
  end
end
