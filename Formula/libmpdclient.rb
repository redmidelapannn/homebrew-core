class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.14.tar.xz"
  sha256 "0a84e2791bfe3077cf22ee1784c805d5bb550803dffe56a39aa3690a38061372"
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d2cfaaa9d604ce21b9846c6cdcec5dc6465812be327eb55a00df41142c460c37" => :high_sierra
    sha256 "92665e3e91929090545cc1e8cf2b18073ebe1c0a244833c46d88c0cb74897678" => :sierra
    sha256 "b64ca8dd8b4061ff706e409818a0c46b6b21f4f6443507351d75c97f445af184" => :el_capitan
  end

  depends_on "doxygen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "--prefix=#{prefix}", ".", "output"
    system "ninja", "-C", "output"
    system "ninja", "-C", "output", "install"
  end
end
