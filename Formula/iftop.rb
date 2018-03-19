# Version is "pre-release", but is what Debian, MacPorts, etc.
# package, and upstream has not had any movement in a long time.
class Iftop < Formula
  desc "Display an interface's bandwidth usage"
  homepage "http://www.ex-parrot.com/~pdw/iftop/"
  url "http://www.ex-parrot.com/pdw/iftop/download/iftop-1.0pre4.tar.gz"
  sha256 "f733eeea371a7577f8fe353d86dd88d16f5b2a2e702bd96f5ffb2c197d9b4f97"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "167b2f9c4b9c2db1880a4994a927193c33715d526d8a6095b605396fc7971c8d" => :high_sierra
    sha256 "3e9c70c9d4b3f2aedec98f5f71919f6f6be7131d6c24d33bea319b2b526261b9" => :sierra
    sha256 "3947d078f8cbc3167392f345edf1c6ba7158e26b87ca674cf082193efdd81179" => :el_capitan
  end

  head do
    url "https://code.blinkace.com/pdw/iftop.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  def caveats; <<~EOS
    iftop requires root privileges so you will need to run `sudo iftop`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    assert_match "interface:", pipe_output("#{sbin}/iftop -t -s 1 2>&1")
  end
end
