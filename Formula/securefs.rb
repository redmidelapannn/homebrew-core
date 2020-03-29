class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs.git",
    :tag      => "0.11.1",
    :revision => "dfeebf8406871d020848edde668234715356158c"
  head "https://github.com/netheril96/securefs.git"

  bottle do
    cellar :any
    sha256 "feeb5d6033fa26d3ebd54483c763b25b6b62ab806d8d3e067a55207f315bdab1" => :catalina
    sha256 "f414f42daf10003bb24e8e2c1e491d47f477d7e754c9784527515d2b4af6add7" => :mojave
    sha256 "e10d6b1b7a608d39b6f0bbdade3d1489a0d7e62525412190cc397a063af21e77" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on :osxfuse

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/securefs", "version" # The sandbox prevents a more thorough test
  end
end
