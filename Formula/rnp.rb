class Rnp < Formula
  desc "The Ribose fork of NetPGP."
  homepage "https://github.com/riboseinc/rnp"
  url "https://github.com/riboseinc/rnp/archive/3.99.18.tar.gz"
  sha256 "b61ae76934d4d125660530bf700478b8e4b1bb40e75a4d60efdb549ec864c506"
  head "https://github.com/riboseinc/rnp.git", :using => :git

  bottle do
    cellar :any
    sha256 "1406ba606ad42984f9b8e6dea2914b7c0ef6f3c2e9d308b788f6a15766b9f30f" => :sierra
    sha256 "839b8d54023ca7111bee0c57dc5eb51743adaf63b681e5245fd0693530a41f5f" => :el_capitan
    sha256 "09072b849fdde7d5fefe6d4aacfb0526ccb7043a92f2dd02feeaa217b55f8787" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"

  def install
    # Generate the configure/Make files. Ideally this won't be necessary
    # in the future.

    mkdir "m4"
    system "autoreconf", "-ivf"

    # Configure, make, and install.

    openssl = Formula["openssl"]

    ENV.append "CFLAGS", "-I#{openssl.opt_include}"
    ENV.append "LDFLAGS", "-L#{openssl.opt_lib}"

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-openssl=#{openssl.opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"netpgp", "--version"
  end
end
