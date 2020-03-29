class GitTrim < Formula
  desc "Trim your git remote tracking branches that are merged or gone"
  homepage "https://github.com/foriequal0/git-trim"
  url "https://github.com/foriequal0/git-trim/archive/v0.3.1.tar.gz"
  sha256 "e8363a4123f39d2dc1aa99cc0030c012adb8057563cb880a7b69fc634edb0f74"

  bottle do
    cellar :any
    sha256 "0c9bc049e41eebec3fa91a0fa885ce921ad13092f7c3f2e9cebb8e0ce423b1c5" => :catalina
    sha256 "dec9caa9b2e272716179860544b682bf01684023f41e51c6cc22f14123026386" => :mojave
    sha256 "8b7a800b28e366da219ec7b122a922b2f8a8b65ba8c2a5a0cd5d7d5bfcf3180f" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    man1.install "docs/git-trim.man" => "git-trim.1"
  end

  test do
    system "git", "clone", "https://github.com/foriequal0/git-trim"
    Dir.chdir("git-trim")
    system "git", "branch", "brew-test"
    assert_match "brew-test", shell_output("git trim")
  end
end
