class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.2.2.tar.gz"
  sha256 "6487b89afa5f2b57d6905cdb45b5e596eb18ed0081f311f6a260324b460f610a"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    rebuild 1
    sha256 "00796c90873d046fb3fe70cd40c744b92ba99ff44158ca721d93c00cf4c92179" => :sierra
    sha256 "29e6d51145f5a199e35e18ca0aef42852ddd376eec9ce3828df3e191160ef275" => :el_capitan
    sha256 "d6d1e2c1f72979deb762a6f825fe05a1083822d716d038ebb62e01e30c79e720" => :yosemite
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.3.0-rc.1.tar.gz"
    sha256 "7ff9a5d5983b8825d59a806e52315092c39138a8b3e34557b943ea22a8c393d6"
    version "1.3.0-rc.1"
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version")
  end
end
