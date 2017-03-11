class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "https://www.hboehm.info/gc/"
  url "https://www.hboehm.info/gc/gc_source/gc-7.6.0.tar.gz"
  sha256 "a14a28b1129be90e55cd6f71127ffc5594e1091d5d54131528c24cd0c03b7d90"

  bottle do
    rebuild 1
    sha256 "a82caf4e655d2b8f9c66be8915903419c84f5cc3bf133117256d21ccb9ad2e5d" => :sierra
    sha256 "a65f13f2064fb98016bfaa9ff17c7a2a45e63e7c25dd924eeb930b9f20dbdf89" => :el_capitan
    sha256 "04ebad9df50f83b62a889ca906edabd8251d6922bb4084af96a6f4c332e6ef29" => :yosemite
  end

  head do
    url "https://github.com/ivmai/bdwgc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libatomic_ops" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cplusplus"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
