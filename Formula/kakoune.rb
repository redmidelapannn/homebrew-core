class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2018.04.13/kakoune-2018.04.13.tar.bz2"
  sha256 "cd8ccf8d833a7de8014b6d64f0c34105bc5996c3671275b00ced77996dd17fce"
  head "https://github.com/mawww/kakoune.git"

  bottle do
    rebuild 1
    sha256 "9c329bd685600663d9addba1a47bd4817ff11beb003b833c0bc7d0d7031d2c09" => :high_sierra
    sha256 "9a5dc70a93adb24da052ffdfe492fba668530c33a1ab952f419f366951fbaafb" => :sierra
    sha256 "05fa12c109c8f976597b9c89e158a57ec3b303dd93563b7ddbc0e77db593c935" => :el_capitan
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
