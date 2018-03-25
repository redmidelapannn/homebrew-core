class Libdnet < Formula
  desc "Portable low-level networking library"
  homepage "https://github.com/dugsong/libdnet"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libdnet/libdnet-1.12.tgz"
  sha256 "83b33039787cf99990e977cef7f18a5d5e7aaffc4505548a83d31bd3515eb026"

  bottle do
    cellar :any
    rebuild 3
    sha256 "1a81a7a7d0093b39e08aae203c96aea70525ab8a62d851c2c489b5737f875d3d" => :high_sierra
    sha256 "f9c7aabcc3f34fa4c8d45a982853f2d37159691d1b9cf87b014e370ee363ac25" => :sierra
    sha256 "81a386edf84a59083626c7d205dfba9f76a0f0d16ee98660b0c932c56d35073d" => :el_capitan
  end

  option "without-python", "Build without python support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "python@2" if MacOS.version <= :snow_leopard

  def install
    # autoreconf to get '.dylib' extension on shared lib
    ENV.append_path "ACLOCAL_PATH", "config"
    system "autoreconf", "-ivf"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-python"
    system "make", "install"
  end

  test do
    system "#{bin}/dnet-config", "--version"
  end
end
