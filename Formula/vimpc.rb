class Vimpc < Formula
  desc "Ncurses based mpd client with vi like key bindings"
  homepage "https://sourceforge.net/projects/vimpc/"
  url "https://downloads.sourceforge.net/project/vimpc/Release%200.09.1/vimpc-0.09.1.tar.gz"
  sha256 "082fa9974e01bf563335ebf950b2f9bc129c0d05c0c15499f7827e8418306031"
  revision 1

  bottle do
    rebuild 1
    sha256 "a2500dcc78346a67f36bf79d9fd54176605b8ae65b8baaf0c208dd2a79cd9759" => :high_sierra
    sha256 "e136691e81820f8801eee8968387c48e148c8506fdfcba5426130fe2bf3bcefa" => :sierra
    sha256 "c4672d885a5a2f00c36dfa0c8a1d0b08abd43d4060357cb04deabda46b0206a4" => :el_capitan
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
