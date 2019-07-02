class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2019.07.01/kakoune-2019.07.01.tar.bz2"
  sha256 "8cf978499000bd71a78736eaee5663bd996f53c4e610c62a9bd97502a3ed6fd3"
  head "https://github.com/mawww/kakoune.git"

  bottle do
    cellar :any
    sha256 "2908ebfaaea13ba96f1dfc66ec99bfcd8143fca7784e14c6c7303101b634e1bf" => :mojave
    sha256 "e8adc1509dc2aeba587ea522f74696cca20e7ab5184e0a2b6156b885258887db" => :high_sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "ncurses"

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
