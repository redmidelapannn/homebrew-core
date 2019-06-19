class TaskSpooler < Formula
  desc "Batch system to run tasks one after another"
  homepage "https://vicerveza.homeunix.net/~viric/soft/ts/"
  url "https://vicerveza.homeunix.net/~viric/soft/ts/ts-1.0.tar.gz"
  sha256 "4f53e34fff0bb24caaa44cdf7598fd02f3e5fa7cacaea43fa0d081d03ffbb395"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "57b10c9fbd54ead74e879c5dee92a54ced4839e0862d405ae9422d6cadade02f" => :mojave
    sha256 "563fb19a0c8f282583d195d723efb0e617f15b8e61a61c5b2b5adbc1798804fa" => :high_sierra
    sha256 "c59ed2ed44e6dab3752d225f36eef163b8191aa71721c261622419fce568a4c1" => :sierra
  end

  conflicts_with "moreutils", :because => "both install a `ts` executable."

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ts", "-l"
  end
end
