class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/about"
  url "https://github.com/D-Programming-Language/dub/archive/v0.9.24.tar.gz"
  sha256 "88fe9ff507d47cb74af685ad234158426219b7fdd7609de016fc6f5199def866"
  head "https://github.com/D-Programming-Language/dub.git", :shallow => false

  bottle do
    revision 1
    sha256 "6934ca8659566e57d4442be63f1a2b2e4a86f07e284aa71fec9b467879b3fa59" => :el_capitan
    sha256 "3d7ede261a7b0cb4c0131db40a344f941d14ff631f80bf3b77c4c4b0d254594a" => :yosemite
    sha256 "ce2d47134604a5f5b8458deda31710e73ee0a6f8b8635a24e7c698057fd0b39f" => :mavericks
  end

  devel do
    url "https://github.com/rejectedsoftware/dub/archive/v0.9.25-beta.3.tar.gz"
    sha256 "c67dc40757cbe0b422f7d38669b786ff344a7dc752bb78aa1652c2b0c405de34"
    version "0.9.25-beta.3"
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
