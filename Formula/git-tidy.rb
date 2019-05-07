class GitTidy < Formula
  desc "Delete git branches that have a remote tracking branch that is : gone"
  homepage "https://github.com/drewwyatt/git-tidy"
  url "https://github.com/drewwyatt/git-tidy/archive/1.0.0.tar.gz"
  sha256 "5bdae85d8ac4fe59305781846229017a8649d894f82ed9cba243ea1a534bd511"
  bottle do
    cellar :any_skip_relocation
    sha256 "b91a8c07669713883ab27a29acd40ff240f79b3d0371e4389387665ac6c8c992" => :mojave
    sha256 "f5539f86dccdf004155ec4b32212cfcb3ea64180cc22efc93cea4b6b09636bd6" => :high_sierra
    sha256 "deae6278dc9435788c6d6fad9cb73d0494d0741311fa7ad7d012a8746e196d21" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.version=#{version}"
    bin.install "git-tidy"
  end

  test do
    output = `git tidy -v`
    expected = "#{version}\n"
    assert_equal expected, output
  end
end
