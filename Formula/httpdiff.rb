class Httpdiff < Formula
  desc "Compare two HTTP(S) responses"
  homepage "https://github.com/jgrahamc/httpdiff"
  url "https://github.com/jgrahamc/httpdiff/archive/v1.0.0.tar.gz"
  sha256 "b2d3ed4c8a31c0b060c61bd504cff3b67cd23f0da8bde00acd1bfba018830f7f"

  head "https://github.com/jgrahamc/httpdiff.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8d2713a38534d1d175e9d622839afb9ddc839c3d27131b779582f8c5fea3a26e" => :sierra
    sha256 "8e9755e94ddd87107367b5d0dcc823399f14f4c9c31de6fb448b29935af900af" => :el_capitan
    sha256 "588245f4f6222ab440ff7242bbfdd9ab32d876560b48b8e5389fdb72f6736a8c" => :yosemite
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"httpdiff"
  end

  test do
    system bin/"httpdiff", "https://brew.sh/", "https://brew.sh/"
  end
end
