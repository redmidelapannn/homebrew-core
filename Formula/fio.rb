class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://git.kernel.dk/cgit/fio/"
  url "https://github.com/axboe/fio/archive/fio-3.0.tar.gz"
  sha256 "80c65159af1e1aeec97f9ddad9f7e213b1abd5f413d1a3dd9ac00a344c6e399d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "66f4d47940f46e05ecd79ff4e6fe00bf2bd8253ae1aca5469f44bd94187a3270" => :sierra
    sha256 "f2c98c58c92100bcf7c10d723cbd2a30a0f66b744e15993e8bb91f0f7a4c5cd0" => :el_capitan
    sha256 "0c84acca8ccf637e00e3fab355ddd065f886ab106cd5e2880734b9120cfda948" => :yosemite
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
