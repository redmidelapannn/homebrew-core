class Libaacs < Formula
  desc "Implements the Advanced Access Content System specification"
  homepage "https://www.videolan.org/developers/libaacs.html"
  url "https://download.videolan.org/pub/videolan/libaacs/0.9.0/libaacs-0.9.0.tar.bz2"
  sha256 "47e0bdc9c9f0f6146ed7b4cc78ed1527a04a537012cf540cf5211e06a248bace"

  bottle do
    cellar :any
    sha256 "0831d6848be292e3913b54ee4feac02d66c6f31a85b5c48bfe168a56d697052e" => :sierra
    sha256 "897aedb3cff662e4cff1f44a230283dcdd613cc337621fb5c6ebab53b43a06df" => :el_capitan
    sha256 "765f820e5d6cfef43f704fd1f5a1b159b5e364ed12738f4282a6fdc78ed9e71d" => :yosemite
  end

  head do
    url "https://git.videolan.org/git/libaacs.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "libgcrypt"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
