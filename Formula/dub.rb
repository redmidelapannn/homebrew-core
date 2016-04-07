class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/about"
  url "https://github.com/D-Programming-Language/dub/archive/v0.9.24.tar.gz"
  sha256 "88fe9ff507d47cb74af685ad234158426219b7fdd7609de016fc6f5199def866"
  head "https://github.com/D-Programming-Language/dub.git", :shallow => false

  bottle do
    revision 1
    sha256 "9c41efde1bd4804f86455a68b64e7b6555b6e4bd82925bab20d9ee381d72a480" => :el_capitan
    sha256 "403ebe62b48143826794ad3ccc727089fbaecaca08b9ccb4b9fb0e5d669ad971" => :yosemite
    sha256 "089aa794e1c90750cc72a131f64afb237ff7f112208c96d5815293690b768e38" => :mavericks
  end

  devel do
    url "https://github.com/D-Programming-Language/dub/archive/v0.9.25-alpha.1.tar.gz"
    sha256 "c6823569045b3528238d2d2f372be1a7e4a15b0c31c5584e5d09bc646767131a"
    version "0.9.25-alpha.1"
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
