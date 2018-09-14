class Xboard < Formula
  desc "Graphical user interface for chess"
  homepage "https://www.gnu.org/software/xboard/"
  url "https://ftp.gnu.org/gnu/xboard/xboard-4.9.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/xboard/xboard-4.9.1.tar.gz"
  sha256 "2b2e53e8428ad9b6e8dc8a55b3a5183381911a4dae2c0072fa96296bbb1970d6"
  revision 2

  bottle do
    rebuild 1
    sha256 "05343dfcb1094a506186c98ce4164385fea343f36e3efb61ddf2959e7aafd259" => :mojave
    sha256 "72a86bdd8a6c9bd85f3d5117bfc3eaa3738cc9596de2042cfec9cbc7b8d4d21a" => :high_sierra
    sha256 "2598c64d47a0584991c91d2cfe374169ff457136878c68bafae802fb42d694dc" => :sierra
    sha256 "8015af7cea521d8b8859de1c42c564cef0f3905f7846ed52588607cf6cae294e" => :el_capitan
  end

  head do
    url "https://git.savannah.gnu.org/git/xboard.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fairymax"
  depends_on "gettext"
  depends_on "gtk+"
  depends_on "librsvg"
  depends_on "polyglot"

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
