class Sl < Formula
  desc "Prints a steam locomotive if you type sl instead of ls"
  homepage "https://github.com/mtoyoda/sl"
  url "https://github.com/mtoyoda/sl/archive/5.02.tar.gz"
  sha256 "1e5996757f879c81f202a18ad8e982195cf51c41727d3fea4af01fdcbbb5563a"

  head "https://github.com/mtoyoda/sl.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "673458d8cfd37d45b53f0ea93b67e7916f1069029111286b636face417e5f3d7" => :high_sierra
    sha256 "781f637761c449695ea604dc899310ceb950e3960bd98031b6fedef394837b62" => :sierra
    sha256 "9b928866e9145a0eb89fa5a94b5bce88f1b5dc448c19a4ce82c4eeab0a9da7d2" => :el_capitan
  end

  fails_with :clang do
    build 318
  end

  def install
    system "make", "-e"
    bin.install "sl"
    man1.install "sl.1"
  end

  test do
    system "#{bin}/sl", "-c"
  end
end
