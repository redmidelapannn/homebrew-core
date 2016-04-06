class BatsSupport < Formula
  desc "Supporting library for Bats test helpers"
  homepage "https://github.com/ztombol/bats-support"
  url "https://github.com/ztombol/bats-support/archive/v0.2.0.tar.gz"
  sha256 "9bfa93d2db046e375e31e4c6cbbe834b015c695862c2dca1b46b71401de1038d"
  bottle do
    cellar :any_skip_relocation
    sha256 "c1bf5a70914199333b5a5e69ffafc5d00ede17321e56d040541b310a9901bfd8" => :el_capitan
    sha256 "7c00b02a048427b289e3291130a94cbf80d6e55d3b90d2d99f2d9899df6e1875" => :yosemite
    sha256 "21f83298ab9543d23641d07e7d8dedcb1beb88b019976087f61e269b8d48df37" => :mavericks
  end

  depends_on "bats"

  def install
    mkdir "bats-support"
    mv "load.bash", "bats-support/"
    mv "src", "bats-support/"
    mv "test", "bats-support/"
    lib.install "bats-support"
    ohai "Use `load '/usr/local/lib/bats-support/load'` in your bats test to load this library."
  end

  test do
    system "bats", "#{lib}/bats-support/test"
  end
end
