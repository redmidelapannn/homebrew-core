class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-1.10.2.tar.gz"
  sha256 "d69d06a3bde6c192324489b05503b5584c7c7969f2540deeb269c370fdc75cda"
  revision 1
  head "https://github.com/algernon/riemann-c-client.git"

  bottle do
    cellar :any
    sha256 "23ad7db61fddb7be6970f343bb15b3be72e7438714c96e15e792869b91243bdb" => :high_sierra
    sha256 "0c5edbd262435a43dbbb999c73639df4ee8f94c2d8c88622420a3bbae286c4c7" => :sierra
    sha256 "4eb9982daa9ec5d13d815bd057372084a900e5138a2a4d2713fd5e50277bb4b0" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

  depends_on "json-c"
  depends_on "protobuf-c"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/riemann-client", "send", "-h"
  end
end
