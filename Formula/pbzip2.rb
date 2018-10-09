class Pbzip2 < Formula
  desc "Parallel bzip2"
  homepage "https://web.archive.org/web/20180226093549/compression.ca/pbzip2/"
  url "https://launchpad.net/pbzip2/1.1/1.1.13/+download/pbzip2-1.1.13.tar.gz"
  sha256 "8fd13eaaa266f7ee91f85c1ea97c86d9c9cc985969db9059cdebcb1e1b7bdbe6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cec786f618eeaee93ee0c855e716fae9832ea14e80e28da2a37c745d06e542ed" => :mojave
    sha256 "d4caa497cc5231ae2b8fef2e2c7d01324bbbebe0911e4d9e417000019f479cb9" => :high_sierra
    sha256 "b4fbd84f339a89550f545c0218b37ca970e20d1107e9edf1e6ef3dc8f6ffd43c" => :sierra
  end

  def install
    system "make", "PREFIX=#{prefix}",
                   "CC=#{ENV.cxx}",
                   "CFLAGS=#{ENV.cflags}",
                   "PREFIX=#{prefix}",
                   "install"
  end

  test do
    system "#{bin}/pbzip2", "--version"
  end
end
