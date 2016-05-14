class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/about"
  url "https://github.com/D-Programming-Language/dub/archive/v0.9.24.tar.gz"
  sha256 "88fe9ff507d47cb74af685ad234158426219b7fdd7609de016fc6f5199def866"
  head "https://github.com/D-Programming-Language/dub.git", :shallow => false

  bottle do
    sha256 "bf14b900869d28bc8140731ee81d04d9ee5b456603dea51353863bd76358f49d" => :el_capitan
    sha256 "5cdd5f8c6729f3acf955afbd8d383daf196318bf1d2278085a28c28af00d33ce" => :yosemite
    sha256 "33db147c048a39cad51569940ff489e015a08f3d17d0c299efcce89c064a8513" => :mavericks
  end

  devel do
    url "https://github.com/rejectedsoftware/dub/archive/v0.9.25-rc.1.tar.gz"
    sha256 "577e127e5e361d1ed7fe6ef40100e91e361dd7063f304afeab7ae5a6274005de"
    version "0.9.25-rc.1"
  end

  depends_on "pkg-config" => :build
  depends_on "dmd" => :build

  def install
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    system "#{bin}/dub; true"
  end
end
