class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "https://ipmitool.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.18/ipmitool-1.8.18.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/i/ipmitool/ipmitool_1.8.18.orig.tar.bz2"
  sha256 "0c1ba3b1555edefb7c32ae8cd6a3e04322056bc087918f07189eeedfc8b81e01"
  revision 3

  bottle do
    cellar :any
    sha256 "4a92ec76eeef3cf6498e2725437fadc257ae0e41b1814e7b4df45615ed25791c" => :mojave
    sha256 "f689ffab8bd0a7bcf70578cf7c7fee9a66c73d1abb80ae18554c6c656a1d782f" => :high_sierra
    sha256 "a787cde0837ac0a5f6e043e87829f8476bfbc9e95b52c3fe54d3cfe2fffe8010" => :sierra
  end

  option "with-shell", "Enable ipmitool shell function."

  depends_on "openssl"
  if build.with? "shell"
    depends_on "readline"
  end

  # https://sourceforge.net/p/ipmitool/bugs/433/#89ea and
  # https://sourceforge.net/p/ipmitool/bugs/436/ (prematurely closed):
  # Fix segfault when prompting for password
  # Re-reported 12 July 2017 https://sourceforge.net/p/ipmitool/mailman/message/35942072/
  patch do
    url "https://gist.githubusercontent.com/adaugherity/87f1466b3c93d5aed205a636169d1c58/raw/29880afac214c1821e34479dad50dca58a0951ef/ipmitool-getpass-segfault.patch"
    sha256 "fc1cff11aa4af974a3be191857baeaf5753d853024923b55c720eac56f424038"
  end

  def install
    # Fix ipmi_cfgp.c:33:10: fatal error: 'malloc.h' file not found
    # Upstream issue from 8 Nov 2016 https://sourceforge.net/p/ipmitool/bugs/474/
    inreplace "lib/ipmi_cfgp.c", "#include <malloc.h>", ""

    if build.with? "shell"
      args = %W[
        --disable-dependency-tracking
        --prefix=#{prefix}
        --mandir=#{man}
        --disable-intf-usb
        --enable-intf-lanplus
        --enable-ipmishell
      ]
    else
      args = %W[
        --disable-dependency-tracking
        --prefix=#{prefix}
        --mandir=#{man}
        --disable-intf-usb
        --enable-intf-lanplus
      ]
    end
    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  test do
    # Test version print out
    system bin/"ipmitool", "-V"
  end
end
