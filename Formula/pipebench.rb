class Pipebench < Formula
  desc "Measure the speed of STDIN/STDOUT communication"
  homepage "http://www.habets.pp.se/synscan/programs.php?prog=pipebench"
  # Upstream server behaves oddly: https://github.com/Homebrew/homebrew/issues/40897
  # url "http://www.habets.pp.se/synscan/files/pipebench-0.40.tar.gz"
  url "https://deb.debian.org/debian/pool/main/p/pipebench/pipebench_0.40.orig.tar.gz"
  sha256 "ca764003446222ad9dbd33bbc7d94cdb96fa72608705299b6cc8734cd3562211"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4a84cb6768eba72b85cc5140c915c3cf74ffc4a3deff9a33c2fff2cb1f738636" => :mojave
    sha256 "c7be5e8ec12b9f1ab0a496425054667ba1b81ef3194bad7dbee6ab70b43d4212" => :high_sierra
    sha256 "d64b355efed693ace95359bb0d0093e19e843a3f9d48cae63040e3dc97038aac" => :sierra
  end

  def install
    system "make"
    bin.install "pipebench"
    man1.install "pipebench.1"
  end

  test do
    system "#{bin}/pipebench", "-h"
  end
end
