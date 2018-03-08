class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://git.kernel.dk/cgit/fio/"
  url "https://github.com/axboe/fio/archive/fio-3.5.tar.gz"
  sha256 "595c8ff34a327792abce4399591ec30c733e9a9ad9f633270ceda50632a7cd7b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5fa2ea68b0657fce20b9e507a0454b36d8b2030289daa49f21f96fb31199fa9b" => :high_sierra
    sha256 "58265b9a2a8acea6abd9fa9c2fa1bf6e3b7df4cc3f9fe95755d6e483060529d7" => :sierra
    sha256 "a18f6bd0d17d0a2a104ce6533e891cddcb3ed17b2dee1d7afb40f50f75bc4761" => :el_capitan
  end

  def install
    system "./configure", "--cc=#{ENV.cc}",
                          "--disable-optimizations",
                          "--extra-cflags=#{ENV.cflags}"
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "V=1", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system "#{bin}/fio", "--parse-only"
  end
end
