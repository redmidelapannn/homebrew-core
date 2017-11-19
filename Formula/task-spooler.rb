class TaskSpooler < Formula
  desc "Batch system to run tasks one after another"
  homepage "http://vicerveza.homeunix.net/~viric/soft/ts/"
  url "http://vicerveza.homeunix.net/~viric/soft/ts/ts-1.0.tar.gz"
  sha256 "4f53e34fff0bb24caaa44cdf7598fd02f3e5fa7cacaea43fa0d081d03ffbb395"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f76e01ed92072d5a579956167828c70923398a3ba318ce5f3ad27fe493952492" => :high_sierra
    sha256 "22df73414825447c237359931773ce3961139b6e9d4ab941e4edbd3c39acfaad" => :sierra
    sha256 "a8e539002726b1ce207ef29627d39f2556cfc099d26b70ae49622ba41bfcb1ec" => :el_capitan
  end

  conflicts_with "moreutils",
    :because => "both install a 'ts' executable."

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ts", "-l"
  end
end
