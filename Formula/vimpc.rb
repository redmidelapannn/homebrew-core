class Vimpc < Formula
  desc "Ncurses based mpd client with vi like key bindings"
  homepage "https://sourceforge.net/projects/vimpc/"
  url "https://downloads.sourceforge.net/project/vimpc/Release%200.09.1/vimpc-0.09.1.tar.gz"
  sha256 "082fa9974e01bf563335ebf950b2f9bc129c0d05c0c15499f7827e8418306031"
  revision 1

  bottle do
    rebuild 1
    sha256 "ca95f3d227ecd9358d149b037b681403658ef921875d5421862963e3a278e0c4" => :high_sierra
    sha256 "464e762b067108194bf545fce431eab34f54f182600de6fa7fa4f397149c7d62" => :sierra
    sha256 "46cdcba814616eac311f06f3ca3e048fce74749a291d69b701230c9171f114b4" => :el_capitan
  end

  head do
    url "https://github.com/boysetsfrog/vimpc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build unless MacOS.version >= :mavericks
  depends_on "taglib"
  depends_on "libmpdclient"
  depends_on "pcre"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/vimpc", "-v"
  end
end
