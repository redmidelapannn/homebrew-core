class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client.git",
      :revision => "7bfcc65197b084b03ed942df5f24806c33cd121e"
  version "1.10.1"
  head "https://github.com/algernon/riemann-c-client.git"

  bottle do
    cellar :any
    sha256 "8040b7ff68fa69249f052d2e82e5551f1b56bc85697b4423a061cb6f6db07587" => :sierra
    sha256 "3702c9326a61cc3be9180b2868fc7f81ea9d5375fd73ac45b20f53b6eb773c60" => :el_capitan
    sha256 "566b89b0847cc4b50422871607c347944af3f8f8b6ca502c33a1a68a52670843" => :yosemite
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
