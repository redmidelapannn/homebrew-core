class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4%2b20151223.gitfa8646d.1.orig.tar.gz"
  version "2.4+20151223"
  sha256 "5c032f5c8cc2937eb55a81a94effdfed3b0a0304b6376147b86f951e225e3ab5"

  head "git://git.ffmpeg.org/rtmpdump", :shallow => false

  bottle do
    cellar :any
    revision 1
    sha256 "ba053331cf176348b71a20487ed637e03d1590b71eddd38f7041683592353baa" => :el_capitan
    sha256 "012a0b6db5348ea8ca025f7a5a75fad897f3dff26fda26053033604d1ab3aa72" => :yosemite
    sha256 "25e1e5403f0fa974d0150818f2315d471e896bb51668c22d788163af79a222db" => :mavericks
  end

  conflicts_with "flvstreamer", :because => "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

  depends_on "openssl"

  fails_with :llvm do
    build 2336
    cause "Crashes at runtime"
  end

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
