class Truncate < Formula
  desc "Truncates a file to a given size"
  homepage "https://www.vanheusden.com/truncate/"
  url "https://github.com/flok99/truncate/archive/0.9.tar.gz"
  sha256 "a959d50cf01a67ed1038fc7814be3c9a74b26071315349bac65e02ca23891507"
  head "https://github.com/flok99/truncate.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ec5f52add960dc5ed74f847a1c55825a3180d0fbfb486f09fac4806396416415" => :catalina
    sha256 "1e22088ad8548bc6f15c5f2b86a9dcc98c475fd09f25852239a3fcc167efb9f1" => :mojave
    sha256 "33b4abe82173a660a3cf2e194c4aa6938de16c64ed9dcb91463b91812d0c075a" => :high_sierra
  end

  conflicts_with "coreutils", :because => "both install `truncate` binaries"

  def install
    system "make"
    bin.install "truncate"
    man1.install "truncate.1"
  end

  test do
    system "#{bin}/truncate", "-s", "1k", "testfile"
  end
end
