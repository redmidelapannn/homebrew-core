class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "http://utopia.knoware.nl/~hlub/rlwrap/"
  url "https://github.com/hanslub42/rlwrap/archive/v0.42.tar.gz"
  sha256 "fff56c24341f0c717cf3a8f0ebbf2cba415b1952e1591168ca69ed13638b20f3"
  revision 1

  head "https://github.com/hanslub42/rlwrap.git"

  bottle do
    rebuild 1
    sha256 "48ffd6e64241e4d454e2feab742493c70227b16c43745c484704e151f7212e11" => :sierra
    sha256 "02708f2f7fd7b63db34f7b3c0d454fcd61cf6b1956de32c9db1e89cae2aee2db" => :el_capitan
    sha256 "9ae6b199a0ca1dc2837d48a7f22c025d66581b34d2b8de328178d427972474a6" => :yosemite
  end

  depends_on "readline"
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-v", "-i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
