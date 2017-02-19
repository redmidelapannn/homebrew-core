class Libmp3splt < Formula
  desc "Utility library to split mp3, ogg, and FLAC files"
  homepage "https://mp3splt.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.9.2/libmp3splt-0.9.2.tar.gz"
  sha256 "30eed64fce58cb379b7cc6a0d8e545579cb99d0f0f31eb00b9acc8aaa1b035dc"

  bottle do
    rebuild 1
    sha256 "6927fd1e6b2d19fa045777fb075852abab3bd0b949151e1e3c2ca04613528fa2" => :sierra
    sha256 "3913155c833bc74caf732de538ed2a8c0994fb1de38ef73eb92d8f3e65beda7e" => :el_capitan
    sha256 "8f9bcc3b9ab043f43b9d5f6fa03f993211cc88174b862236e61f4041ed2adca1" => :yosemite
  end

  depends_on "libtool" => :run
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "pcre"
  depends_on "libid3tag"
  depends_on "mad"
  depends_on "libvorbis"
  depends_on "flac"
  depends_on "libogg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
