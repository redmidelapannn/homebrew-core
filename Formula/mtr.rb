class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "https://www.bitwizard.nl/mtr/"
  url "https://github.com/traviscross/mtr/archive/v0.92.tar.gz"
  sha256 "568a52911a8933496e60c88ac6fea12379469d7943feb9223f4337903e4bc164"
  head "https://github.com/traviscross/mtr.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7e1d2c0eca2a4f487a109696fe223726957b745575d69775c59aa83b5d15fc78" => :sierra
    sha256 "671110361906f1a549de1edb49980aba004267d71905788a3ccb1675aa257903" => :el_capitan
    sha256 "a3348d07eb80d3870195b4a4040873528fca92483f81744b6c716bb6ab3d288e" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+" => :optional
  depends_on "glib" => :optional

  def install
    # We need to add this because nameserver8_compat.h has been removed in Snow Leopard
    ENV["LIBS"] = "-lresolv"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--without-gtk" if build.without? "gtk+"
    args << "--without-glib" if build.without? "glib"
    system "./bootstrap.sh"
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    mtr requires root privileges so you will need to run `sudo mtr` or
    setuid-root the #{sbin}/mtr-packet binary.
    You should be certain that you trust any software you grant root privileges.

    More information on security and mtr is available here:
    https://github.com/traviscross/mtr/blob/master/SECURITY
    EOS
  end

  test do
    system sbin/"mtr", "--help"
  end
end
