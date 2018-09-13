class Httest < Formula
  desc "Provides a large variety of HTTP-related test functionality"
  homepage "https://htt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/htt/htt2.4/httest-2.4.23/httest-2.4.23.tar.gz"
  sha256 "52a90c9719b35226ed1e26a5262df0d14aeb63b258187656bf1eb30ace53232c"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "24eb3a08b74689c53c221115a34bf462787f0dabb7cc579b91ef121f42a00145" => :mojave
    sha256 "9a096a1542ec64901a114ae2253d658c94fa4da8400c7125a79264a3998bfba3" => :high_sierra
    sha256 "5dfae11d19f87be4a4f4b637ccbc96b438f2cc7c81ec77d4226e2a40094a88f4" => :sierra
    sha256 "ac0eb9fae9ec52fa0af262168fcbf652fef883ce312ca96a29bf9fbe7194cf72" => :el_capitan
  end

  depends_on "apr"
  depends_on "apr-util"
  depends_on "lua@5.1"
  depends_on "nghttp2"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "spidermonkey"

  def install
    inreplace "configure",
      "else LUA_LIB_PATH=\"-L${withval}\"; LUA_INCLUDES=\"-I${withval}\"; LUA_LIB=\"-llua\"; fi",
      "else LUA_LIB_PATH=\"-L${withval}/lib\"; LUA_INCLUDES=\"-I${withval}/include/lua-5.1\"; LUA_LIB=\"-llua.5.1\"; fi"

    # Fix "fatal error: 'pcre/pcre.h' file not found"
    # Reported 9 Mar 2017 https://sourceforge.net/p/htt/tickets/4/
    (buildpath/"brew_include").install_symlink Formula["pcre"].opt_include => "pcre"
    ENV.prepend "CPPFLAGS", "-I#{buildpath}/brew_include"

    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for libxml2
    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-h2-module",
                          "--enable-html-module",
                          "--enable-js-module",
                          "--enable-lua-module",
                          "--enable-xml-module",
                          "--with-apr=#{Formula["apr"].opt_bin}",
                          "--with-lua=#{Formula["lua@5.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.htt").write <<~EOS
      CLIENT 5
        _TIME time
      END
    EOS
    system bin/"httest", "--debug", testpath/"test.htt"
  end
end
