class GitTidy < Formula
  desc "Delete git branches that have a remote tracking branch that is : gone"
  homepage "https://github.com/drewwyatt/git-tidy"
  url "https://github.com/drewwyatt/git-tidy/archive/1.0.0.tar.gz"
  sha256 "5bdae85d8ac4fe59305781846229017a8649d894f82ed9cba243ea1a534bd511"
  bottle do
    cellar :any_skip_relocation
    sha256 "ceeeb03dc1e6fa8a8de3d7cdc0d24ac58bf096a6340784ff075f5871694b52e7" => :mojave
    sha256 "11033ca8d6d6fd98e22198418a40bbe41974dca61898e98a2ea5d4a0a7ec555f" => :high_sierra
    sha256 "6a49f2cda8947d37812d6b17634e47f94933b52a4faac2ea05d2527760509da9" => :sierra
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
