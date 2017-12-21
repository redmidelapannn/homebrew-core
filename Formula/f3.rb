class F3 < Formula
  desc "Test various flash cards"
  homepage "http://oss.digirati.com.br/f3/"
  url "https://github.com/AltraMayor/f3/archive/v7.0.tar.gz"
  sha256 "1aaf63cf73869633e7e03a2e12561a9af0b0fbba013a94b94e78d2868f441d71"
  head "https://github.com/AltraMayor/f3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d42f1a1b454daa7a3f3494673fd6f7ca120d8d8825a713dfd2a3b523eb0b1872" => :high_sierra
    sha256 "99cc5812b07de5946991cabf6051527e15bbbd84f8cdbf461ad7e4ade0fdea63" => :sierra
    sha256 "fcd0b54374d43cecf4419dd315353f32bbf7469e8ee0fa3541c9a8eb0969c0ed" => :el_capitan
  end

  depends_on "argp-standalone" => :build # static linkage

  # Fix undefined symbols errors for _argp_error and _argp_parse
  # Upstream PR from 21 Dec "Add ARGP to Makefile"
  patch do
    url "https://github.com/AltraMayor/f3/pull/67.patch?full_index=1"
    sha256 "243f15c42b0e4561990fbd57add0096c2d09e49a5c4a972de1458dc9b71c908c"
  end

  def install
    system "make", "all", "ARGP=#{Formula["argp-standalone"].opt_prefix}"
    bin.install %w[f3read f3write]
    man1.install "f3read.1"
    man1.install_symlink "f3read.1" => "f3write.1"
  end

  test do
    system "#{bin}/f3read", testpath
  end
end
