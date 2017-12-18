class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "http://crosstool-ng.org"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.23.0.tar.xz"
  sha256 "68a43ea98ccf9cb345cb6eec494a497b224fee24c882e8c14c6713afbbe79196"
  head "https://github.com/crosstool-ng/crosstool-ng.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9fa65c5e49d3c10cb2056015583a6a24125edb5ea22edb24fd8ab192c99dc8e8" => :high_sierra
    sha256 "0f38d2a827a0542228447efc6316d5627277744992b0c48f428f26ba4a21bdaa" => :sierra
    sha256 "f594bb1024183c08a9f17e411dcdc39082c7e64969b21cc36f7113088e807ec1" => :el_capitan
  end

  depends_on "bash" => :build
  depends_on "help2man" => :build
  depends_on "autoconf" => :run
  depends_on "automake" => :run
  depends_on "libtool" => :run
  depends_on "binutils"
  depends_on "coreutils"
  depends_on "flex"
  depends_on "gawk"
  depends_on "gnu-sed"
  depends_on "grep"
  depends_on "m4"
  depends_on "xz"

  def install
    ENV["M4"] = "#{Formula["m4"].opt_bin}/m4"

    system "/usr/local/bin/bash", "./bootstrap" if build.head?

    system "./configure", "--prefix=#{prefix}"

    # Must be done in two steps
    system "make"
    system "make", "install"
  end

  test do
    assert_match "This is crosstool-NG", shell_output("make -rf #{bin}/ct-ng version")
  end
end
