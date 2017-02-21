class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "https://github.com/hanslub42/rlwrap"
  url "https://github.com/hanslub42/rlwrap/archive/v0.42.tar.gz"
  sha256 "fff56c24341f0c717cf3a8f0ebbf2cba415b1952e1591168ca69ed13638b20f3"
  revision 1

  head "https://github.com/hanslub42/rlwrap.git"

  bottle do
    rebuild 1
    sha256 "ed8345f43660520191d7d2d3ef445f94cf64fa3ca7de07f962c6f491b2a574d0" => :sierra
    sha256 "e58d6992d3b50f736ad4c87f328b1309a2733e7955c434e8405efa321b59337d" => :el_capitan
    sha256 "51e53f28a3b1c5b4b67ee20d9a936143e54d613f9c71cf0795d5f42a9607d758" => :yosemite
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
