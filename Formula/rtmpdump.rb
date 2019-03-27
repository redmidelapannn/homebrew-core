class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu/"
  url "https://deb.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  version "2.4+20151223"
  sha256 "5c032f5c8cc2937eb55a81a94effdfed3b0a0304b6376147b86f951e225e3ab5"
  head "https://git.ffmpeg.org/rtmpdump", :shallow => false

  bottle do
    cellar :any
    rebuild 1
    sha256 "4d0769796c4df7babd1833eb71c2c8687ea141745b6c2ccebd00f2591a88beb9" => :mojave
    sha256 "12b66bb19b33d44f4906fa66bc5b2d44981882a91ffa9f6bb148d0b6e7e2ac07" => :high_sierra
    sha256 "d4af993fbcfec2db1ee7da3a892bda395820f91b6379d637bae12071f42bee95" => :sierra
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
