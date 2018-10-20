class Kommit < Formula
  desc "More detailed commit messages without committing!"
  homepage "https://github.com/vigo/kommit"
  url "https://github.com/vigo/kommit/archive/v1.1.0.tar.gz"
  sha256 "c51e87c9719574feb9841fdcbd6d1a43b73a45afeca25e1312d2699fdf730161"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "98737085fe645652f105ca0307c52353f9dc3c55a6c4bfa1e67d356881b242fa" => :mojave
    sha256 "b9105b61cc0ab0add311901eba94874b4cc7754eb6639ea4f7550fa2c7adb65d" => :high_sierra
    sha256 "b9105b61cc0ab0add311901eba94874b4cc7754eb6639ea4f7550fa2c7adb65d" => :sierra
  end

  def install
    bin.install "bin/git-kommit"
  end

  test do
    system "git", "init"
    system "#{bin}/git-kommit", "-m", "Hello"
    assert_match /Hello/, shell_output("#{bin}/git-kommit -s /dev/null 2>&1")
  end
end
