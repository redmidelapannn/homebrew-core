class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://developer.mozilla.org/en/SpiderMonkey"
  url "https://people.mozilla.org/~sstangl/mozjs-38.2.1.rc0.tar.bz2"
  version "38.2.1"
  sha256 "01994c758174bc173bcf4960f05ecb4da21014f09641a63b2952bbf9eeaa8b5c"

  head "https://hg.mozilla.org/tracemonkey/archive/tip.tar.gz"

  bottle do
    cellar :any
    sha256 "49be77b75eaa5c6f458656dfdfcc1e7570cb82de4fc77be3b692146c5d826507" => :el_capitan
    sha256 "d7958ba8b20de6307431aebb942990d050947cde05604063ddad83b204f52fa5" => :yosemite
    sha256 "94dc42c0984b699e3e079ac2f806596976e776de2eb4c93d2bc813fdbdd968a3" => :mavericks
  end

  conflicts_with "narwhal", :because => "both install a js binary"

  depends_on "readline"
  depends_on "nspr"

  def install
    mkdir "brew-build" do
      # Configure needs python to figure out which version of libmozjs it is
      # building.
      ENV["PYTHON"] = which "python"
      system "../js/src/configure", "--prefix=#{prefix}",
                                    "--enable-dtrace",
                                    "--enable-readline",
                                    "--enable-threadsafe",
                                    "--with-system-nspr",
                                    "--with-nspr-prefix=#{Formula["nspr"].opt_prefix}",
                                    "--enable-macos-target=#{MacOS.version}"

      # These need to be in separate steps.
      system "make"
      system "make", "install", "STATIC_LIBRARY_NAME=js_static"

      # Also install js REPL.
      bin.install "js/src/shell/js"
    end
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js #{path}").strip
  end
end
