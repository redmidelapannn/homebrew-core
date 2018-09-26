class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.bz2"
  sha256 "7f6130bc3cf65f56a618888ce9d5ea704fa10b462be126ad053e80e553d6d8b7"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3dab113a48527b765424b51779c747599a0924ed312a2d6fc801a7b6f52bace8" => :mojave
    sha256 "5ff68441451b4288d566c24e4ec5b903a7f5d21a2336c3f492b2a5965c6296c5" => :high_sierra
    sha256 "c389582c1e31c6e5fbb872bbdb652a305bd3827000aba7d83ad9c633a77ab89b" => :sierra
  end

  depends_on "boost-build" => :build

  def install
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--help"
  end
end
