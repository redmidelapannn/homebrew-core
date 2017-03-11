class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4%2b20151223.gitfa8646d.1.orig.tar.gz"
  version "2.4+20151223"
  sha256 "5c032f5c8cc2937eb55a81a94effdfed3b0a0304b6376147b86f951e225e3ab5"

  head "https://git.ffmpeg.org/rtmpdump", :shallow => false

  bottle do
    cellar :any
    rebuild 1
    sha256 "3ec5fbc5e2b7803bb80f05a22a72c5b57ee24be30d6c6275198fb4898efc3426" => :sierra
    sha256 "f32560e41f6ecf58c51b68521a9a1ad87745ebc6b3adfa17c7257aae04fb5f52" => :el_capitan
    sha256 "2c9e7e9047c0e51173168074cf8839c5450f00e1c70d72c1eddae42eeb8dd4da" => :yosemite
  end

  depends_on "openssl"

  conflicts_with "flvstreamer", :because => "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

  def install
    ENV.deparallelize
    system "make", "CC=#{ENV.cc}",
                   "XCFLAGS=#{ENV.cflags}",
                   "XLDFLAGS=#{ENV.ldflags}",
                   "MANDIR=#{man}",
                   "SYS=darwin",
                   "prefix=#{prefix}",
                   "sbindir=#{bin}",
                   "install"
  end

  test do
    system "#{bin}/rtmpdump", "-h"
  end
end
