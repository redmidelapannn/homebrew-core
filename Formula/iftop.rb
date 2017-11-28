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
    sha256 "f0ad47a94ed7fe4b18ff49204e84fc8930a7820a7747e3e6522cc79a77817174" => :high_sierra
    sha256 "43938768230d4567a13b674f5b29e0b588d8fba8159444ef5cd83438fe5604f9" => :sierra
    sha256 "c6a01912e171e1c07b27d9f41f97c10786fe5ce0d4e64a3119f900d69a204cf1" => :el_capitan
  end

  head do
    url "https://code.blinkace.com/pdw/iftop.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
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
