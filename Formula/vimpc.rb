class Vimpc < Formula
  desc "Ncurses based mpd client with vi like key bindings"
  homepage "https://sourceforge.net/projects/vimpc/"
  url "https://downloads.sourceforge.net/project/vimpc/Release%200.09.1/vimpc-0.09.1.tar.gz"
  sha256 "082fa9974e01bf563335ebf950b2f9bc129c0d05c0c15499f7827e8418306031"
  revision 1

  bottle do
    rebuild 1
    sha256 "7d7c8239ab40e210839245851238b6cbff73fd22dab4f802041efdffbbd1bb9b" => :mojave
    sha256 "7a90841580033ef101ae4006d2ecb0aa7eefa918310235b0c80f81bcfb0a3928" => :high_sierra
    sha256 "c5d41f8cb341a76069098c574c5d959fe34fbf7212b3ed6375219ae6553bf7cf" => :sierra
  end

  head do
    url "https://github.com/boysetsfrog/vimpc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libmpdclient"
  depends_on "pcre"
  depends_on "taglib"

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
