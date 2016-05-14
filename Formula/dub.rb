class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/about"
  url "https://github.com/D-Programming-Language/dub/archive/v0.9.24.tar.gz"
  sha256 "88fe9ff507d47cb74af685ad234158426219b7fdd7609de016fc6f5199def866"
  head "https://github.com/D-Programming-Language/dub.git", :shallow => false

  bottle do
    revision 1
    sha256 "c33df26bc3177d4cb751b6929abcc429e3e5ac3d3fd41c50e055863447bc1fbd" => :el_capitan
    sha256 "353a8c3efe1232f4d62dcde6153f12cf398db01c2e0078137d1c7769866fe812" => :yosemite
    sha256 "210ccbfcf14aad9312240aedf7ffe4d1cfded3bf4aec5ee168e01e8f1cd8d4a4" => :mavericks
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
