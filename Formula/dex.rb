class Dex < Formula
  desc "Dextrous text editor"
  homepage "https://github.com/tihirvon/dex"
  url "https://github.com/tihirvon/dex/archive/v1.0.tar.gz"
  sha256 "4468b53debe8da6391186dccb78288a8a77798cb4c0a00fab9a7cdc711cd2123"

  head "https://github.com/tihirvon/dex.git"

  bottle do
    rebuild 2
    sha256 "ee385c767772d43fb8e69d8d02a2240b6aed626787409a4e95f222be949cdc00" => :sierra
    sha256 "f357b217c15d94b88ae3d63ba64cb5dad9831fed1ef7716b16bf876af8e46d44" => :el_capitan
    sha256 "6fb03c8cf29ba629396eecf1796efcacba04a3408a76f0d54833558860aef785" => :yosemite
  end

  depends_on "ncurses" => :optional
  depends_on "libiconv" => :optional

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
