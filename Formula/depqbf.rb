class Depqbf < Formula
  desc "Solver for quantified boolean formulae (QBF)"
  homepage "https://lonsing.github.io/depqbf/"
  url "https://github.com/lonsing/depqbf/archive/version-5.01.tar.gz"
  sha256 "ba2b93b3a83917f6084ab88d75b4848ce9354584fb36d70537fa7490e42921bc"
  head "https://github.com/lonsing/depqbf.git"

  bottle do
    cellar :any
    sha256 "e3426b6005c04dfe465718ea78d6bbd7222b016e93fb14bfd22bb4158e67b8e0" => :el_capitan
    sha256 "03082a5625150ae8b6d90267b2287977511e4f01948ac2ab2d8095c7c30bb66e" => :yosemite
    sha256 "d6411a0a44dd26416445dfe0fe769c89486af76c6b1db948341a0daa3d68c7c9" => :mavericks
  end

  def install
    system "make"
    bin.install "depqbf"
    lib.install "libqdpll.a", "libqdpll.1.0.dylib"
  end

  test do
    system "#{bin}/depqbf", "-h"
  end
end
