class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://freecode.com/projects/fio"
  url "https://github.com/axboe/fio/archive/fio-2.17.tar.gz"
  sha256 "4d31ce145cc2d21e91aaf08bb4d14cca942ad6572131cba687906983478ce6e5"
  head "git://git.kernel.dk/fio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "839f0d7d9ba3eb51ee55385b350ce57ff25cdb4fe00d6cf43609adb30fe99110" => :sierra
    sha256 "6d3f3b7d3ddc9a26a4966b740947e4f8c27d192be0c073bb0146aeac0453973d" => :el_capitan
    sha256 "3b92513a02559e8287818248cca29bd6924af0c435fcbc7d565a79babe5fcb03" => :yosemite
  end

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system "#{bin}/fio", "--parse-only"
  end
end
