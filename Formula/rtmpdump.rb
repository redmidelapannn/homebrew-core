class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu/"
  url "https://deb.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  version "2.4+20151223"
  sha256 "5c032f5c8cc2937eb55a81a94effdfed3b0a0304b6376147b86f951e225e3ab5"
  revision 1
  head "https://git.ffmpeg.org/rtmpdump.git", :shallow => false

  bottle do
    cellar :any
    rebuild 1
    sha256 "eea445ef751981cc96372e498f6711e437d0eae3d875c0e163bad7d93339dea3" => :catalina
    sha256 "fdd359a601d28119dfd35151569bcb7dadd566d5ed2e5eed56eb915878f3a013" => :mojave
    sha256 "979f2d98ceda50fee10b95265b8873de82dd292cc5362796ccb4cf8e56886a46" => :high_sierra
  end

  depends_on "openssl@1.1"

  conflicts_with "flvstreamer", :because => "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

  # Patch for OpenSSL 1.1 compatibility
  # Taken from https://github.com/JudgeZarbi/RTMPDump-OpenSSL-1.1
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/rtmpdump/openssl-1.1.diff"
    sha256 "3c9167e642faa9a72c1789e7e0fb1ff66adb11d721da4bd92e648cb206c4a2bd"
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
