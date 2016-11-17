class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v2.1.0.tar.gz"
  sha256 "6fb70b39065a6d6ba1d12915906c06907a3e1afbb25c7653ad23a21217f51c76"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3f948f3f6df9e8f97272cbc50817e5eefb255832128ab4cfe3fc2062e1d08345" => :sierra
    sha256 "3f948f3f6df9e8f97272cbc50817e5eefb255832128ab4cfe3fc2062e1d08345" => :el_capitan
    sha256 "3f948f3f6df9e8f97272cbc50817e5eefb255832128ab4cfe3fc2062e1d08345" => :yosemite
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
