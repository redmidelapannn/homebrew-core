class Spidermonkey < Formula
  desc "Mozilla's JavaScript engine, as used in Firefox"
  homepage "https://developer.mozilla.org/en/SpiderMonkey"
  url "https://archive.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz"
  version "1.8.5"
  sha256 "5d12f7e1f5b4a99436685d97b9b7b75f094d33580227aa998c406bbae6f2a687"
  revision 3

  head "https://hg.mozilla.org/tracemonkey/archive/tip.tar.gz"

  bottle do
    cellar :any
    sha256 "bce361dcf388dbe0c3bcca7455833c3946fbc54e261257951a5dc8c8a941a6e2" => :sierra
    sha256 "a32ab0df85da78fd4eb05d185a0c5a703131fc5fe95c86a2776f5bd1bdb8b844" => :el_capitan
    sha256 "09d21390ceb18b95d2e8ebf766acc5bf73ec441e1cb3b9778a1e0c97c84ab835" => :yosemite
  end

  depends_on "readline"
  depends_on "nspr"

  conflicts_with "narwhal", :because => "both install a js binary"

  def install
    cd "js/src" do
      # Remove the broken *(for anyone but Firefox) install_name
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

      # Install the REPL.
      bin.install "shell/js" => "spidermonkey"
      bin.install_symlink "spidermonkey" => "sm"
    end
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/spidermonkey #{path}").strip
    assert_equal "hello", shell_output("#{bin}/sm #{path}").strip
  end
end
