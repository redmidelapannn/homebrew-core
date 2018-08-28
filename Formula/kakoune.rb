class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2018.04.13/kakoune-2018.04.13.tar.bz2"
  sha256 "cd8ccf8d833a7de8014b6d64f0c34105bc5996c3671275b00ced77996dd17fce"
  head "https://github.com/mawww/kakoune.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9d285cdc93f28fb91553906745a52df561682dbed4e065640755b65d1f7b8cc4" => :high_sierra
    sha256 "0cb5eda2169725e2185de73292da0d83af4707095576eaf03e0aca69ab92955d" => :sierra
    sha256 "8df2561456a0c369eb05fce0de4eabfe4f10fb1a2bee401c03d304e242a7fe90" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build

  if MacOS.version <= :el_capitan
    depends_on "gcc"
    fails_with :clang do
      build 800
      cause "New C++ features"
    end
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    cd "src" do
      system "make", "install", "debug=no", "PREFIX=#{prefix}"
    end
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"
  end
end
