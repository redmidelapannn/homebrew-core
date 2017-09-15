class Apg < Formula
  desc "Tool set for random password generation"
  homepage "https://launchpad.net/ubuntu/+source/apg/2.2.3-1"
  url "https://launchpad.net/ubuntu/+archive/primary/+files/apg_2.2.3.orig.tar.gz"
  sha256 "69c9facde63958ad0a7630055f34d753901733d55ee759d08845a4eda2ba7dba"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "912c6f0d13033f9f54b7b798435e48879340cc580a3b01fc36309b3f43c98b08" => :sierra
    sha256 "21b1e5f95ca9f68d12a0fa20ebd68bd268eb4d673ef0f3a32f93d1c3d042ba0b" => :el_capitan
  end

  def install
    system "make", "standalone",
                   "CC=#{ENV.cc}",
                   "FLAGS=#{ENV.cflags}",
                   "LIBS=", "LIBM="

    bin.install "apg", "apgbfm"
    man1.install "doc/man/apg.1", "doc/man/apgbfm.1"
  end

  test do
    system bin/"apg", "-a", "1", "-M", "n", "-n", "3", "-m", "8", "-E", "23456789"
  end
end
