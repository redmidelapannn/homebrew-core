class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libe/libewf/libewf_20140608.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libe/libewf/libewf_20140608.orig.tar.gz"
  version "20140608"
  sha256 "d14030ce6122727935fbd676d0876808da1e112721f3cb108564a4d9bf73da71"
  revision 1

  bottle do
    cellar :any
    rebuild 3
    sha256 "6d9dab88d5ff9e0841ee233daf0123b26e8db992ed0b38abd14408a80a619aba" => :sierra
    sha256 "db3867db442d72cc986e92a69b20846e8e4d4477d6ad87ecbd87f340f0c75ee3" => :el_capitan
    sha256 "a4b9b2afdb4182ad039ba8cb373706f502e6840236c12abb0ec7b0bef9abdb34" => :yosemite
  end

  devel do
    url "https://github.com/libyal/libewf/releases/download/20170703/libewf-experimental-20170703.tar.gz"
    sha256 "84fe12389abacf63dea2d921b636220bb7fda3262d1c467f6d445a5e31f53ade"
  end

  head do
    url "https://github.com/libyal/libewf.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ewfinfo -V")
  end
end
