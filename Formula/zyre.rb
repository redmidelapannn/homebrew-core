class Zyre < Formula
  desc "Local Area Clustering for Peer-to-Peer Applications"
  homepage "https://github.com/zeromq/zyre"
  url "https://github.com/zeromq/zyre/archive/v1.2.0.tar.gz"
  sha256 "5a47dd553ca699ee7c4b4b11c5ea316d11267adad1bfd3ad48c3c5d608668596"

  bottle do
    cellar :any
    sha256 "f3003dff41f89dc727f67ffb2897261adfe73920382ec3bd95926b505fc32703" => :sierra
    sha256 "8496ace9adda4ff25487401c90763d06d3813f7ee80d0badd01bc61112770b61" => :el_capitan
    sha256 "5e454f3424716f1dd363177f7ce8a47d9df007491de4417e08c06f6e2b4022e7" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "libsodium" => :run
  depends_on "zeromq" => :run
  depends_on "czmq" => :run

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "zpinger"
  end
end
