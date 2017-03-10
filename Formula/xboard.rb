class Xboard < Formula
  desc "Graphical user interface for chess"
  homepage "https://www.gnu.org/software/xboard/"
  url "https://ftpmirror.gnu.org/xboard/xboard-4.9.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/xboard/xboard-4.9.1.tar.gz"
  sha256 "2b2e53e8428ad9b6e8dc8a55b3a5183381911a4dae2c0072fa96296bbb1970d6"
  revision 1

  bottle do
    rebuild 1
    sha256 "c530db99686d58a3a24cf714be5465d2cd65e78b29b3e4c0a414f00964fff6da" => :sierra
    sha256 "e45894b14ac04d72b68067507aae36e0400a3092d39b66edba282a0701b55d06" => :el_capitan
    sha256 "ce00eea4bfcab2be5abc99b579a1a5939454f356d9a6600933cc683e59045e98" => :yosemite
  end

  head do
    url "https://git.savannah.gnu.org/git/xboard.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "fairymax" => :recommended
  depends_on "polyglot" => :recommended
  depends_on "gettext"
  depends_on "cairo"
  depends_on "librsvg"
  depends_on "gtk+"

  def install
    system "./autogen.sh" if build.head?
    args = ["--prefix=#{prefix}",
            "--with-gtk",
            "--without-Xaw",
            "--disable-zippy"]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"xboard", "--help"
  end
end
