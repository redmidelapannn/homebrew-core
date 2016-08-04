class Dex < Formula
  desc "Dextrous text editor"
  homepage "https://github.com/tihirvon/dex"
  url "https://github.com/tihirvon/dex/archive/v1.0.tar.gz"
  sha256 "4468b53debe8da6391186dccb78288a8a77798cb4c0a00fab9a7cdc711cd2123"

  head "https://github.com/tihirvon/dex.git"

  bottle do
    revision 2
    sha256 "3a0e7225456797a9307aa5f74bc169dd1c1faff0307233d086f83de8e28e7c9c" => :el_capitan
    sha256 "7b6fbf8193bb6ed44233aa1f8b04e6029189baf804bc00103db4a66c246682c2" => :yosemite
    sha256 "6a966d89c486fcb15d149e9a351de15cadeab57b279a16057096ea422a5c9e4d" => :mavericks
  end

  depends_on "homebrew/dupes/ncurses" => :optional
  depends_on "homebrew/dupes/libiconv" => :optional

  def install
    args = ["prefix=#{prefix}",
            "CC=#{ENV.cc}",
            "HOST_CC=#{ENV.cc}"]

    args << "VERSION=#{version}" if build.head?

    inreplace "Makefile", /-lcurses/, "-lncurses" if build.with? "ncurses"

    system "make", "install", *args
  end

  test do
    system bin/"dex", "-V"
  end
end
