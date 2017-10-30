class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "http://crosstool-ng.org"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.23.0.tar.xz"
  sha256 "68a43ea98ccf9cb345cb6eec494a497b224fee24c882e8c14c6713afbbe79196"
  revision 1

  bottle do
    cellar :any
    sha256 "10750d5243995d937337cfc45c7de131d27c99d28e98197ce725d87ebb83a5a3" => :high_sierra
    sha256 "03b9ad7a427a65006a43550e2f89fdccb2becbff81a7b75d684d8dfec07765bf" => :sierra
    sha256 "c4727ecc109df5f02bbca1633679b030a11237ed349fc54a91d646774f902166" => :el_capitan
  end

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

    system "./configure", "--prefix=#{prefix}"

    # Must be done in two steps
    system "make"
    system "make", "install"
  end

  test do
    assert_match "This is crosstool-NG", shell_output("make -rf #{bin}/ct-ng version")
  end
end
