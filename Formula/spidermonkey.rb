class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://developer.mozilla.org/en/SpiderMonkey"
  url "https://archive.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz"
  version "1.8.5"
  sha256 "5d12f7e1f5b4a99436685d97b9b7b75f094d33580227aa998c406bbae6f2a687"
  revision 2

  head "https://hg.mozilla.org/mozilla-central", :using => :hg

  bottle do
    cellar :any
    rebuild 1
    sha256 "1de425d5647151c20d75a94fdd66ef4c53898d616643328ae79a136a362656a1" => :sierra
    sha256 "555048a30445b24107fa77000734ef920b13df314ab3d89dc45b7801ee7ca6ec" => :el_capitan
    sha256 "08d7ca51ba88a7c2737429c936bf9704e2f2160df56c2921f8267331273671e9" => :yosemite
  end

  depends_on "readline"
  depends_on "nspr"

  conflicts_with "narwhal", :because => "both install a js binary"

  def install
    cd "js/src" do
      # Remove the broken *(for anyone but FF) install_name
      inreplace "config/rules.mk",
        "-install_name @executable_path/$(SHARED_LIBRARY) ",
        "-install_name #{lib}/$(SHARED_LIBRARY) "
    end

    mkdir "brew-build" do
      system "../js/src/configure", "--prefix=#{prefix}",
                                    "--enable-readline",
                                    "--enable-threadsafe",
                                    "--with-system-nspr",
                                    "--with-nspr-prefix=#{Formula["nspr"].opt_prefix}",
                                    "--enable-macos-target=#{MacOS.version}"

      inreplace "js-config", /JS_CONFIG_LIBS=.*?$/, "JS_CONFIG_LIBS=''"
      # These need to be in separate steps.
      system "make"
      system "make", "install"

      # Also install js REPL.
      bin.install "shell/js"
    end
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js #{path}").strip
  end
end
