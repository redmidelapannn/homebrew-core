class GitReq < Formula
  desc "Check out merge requests from GitLab/GitHub repositories with ease!"
  homepage "https://arusahni.github.io/git-req/"
  url "https://github.com/arusahni/git-req/archive/v2.1.0.tar.gz"
  sha256 "a7bc8f90230762e93d348dcb22dee93b7c47d07678012976a229950a752a72ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "f812f6e238ad0606a2f998f38269b87e24a7cb8ab84dadc7229f1b4e6870591f" => :catalina
    sha256 "61144640eb8319689a75e9e8a9d3e2c70eee33eea1b1694c7f3eca896b971ef2" => :mojave
    sha256 "3f7e25d6f6a0df7d49164af59384cea1797b878ad9afbf1c3cff1dadc29fa455" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match /git-req 2.1.0/, shell_output("#{bin}/git-req --version")
  end
end
