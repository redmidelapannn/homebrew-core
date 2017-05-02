class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "https://www.hboehm.info/gc/"
  url "https://www.hboehm.info/gc/gc_source/gc-7.6.0.tar.gz"
  sha256 "a14a28b1129be90e55cd6f71127ffc5594e1091d5d54131528c24cd0c03b7d90"

  bottle do
    rebuild 1
    sha256 "bf1cd6ccdd2b719e33552aacae47ef890cd18fb4bee1d9abfc556e45f1600971" => :sierra
    sha256 "c0db254a5c709b3646eddf35ab61f9d1d67626c4fcae9886e0f4c52c14f88779" => :el_capitan
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
