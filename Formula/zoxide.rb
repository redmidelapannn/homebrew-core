class Zoxide < Formula
  desc "Fast cd command that learns your habits"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.2.0.tar.gz"
  sha256 "628c394d7b5031cf986c5a8b24083dc5941a21d7491ae916684c3322ac748318"

  bottle do
    cellar :any_skip_relocation
    sha256 "97572c4876291ad80679b57c69698dbbbcfd6759287ae1fc3eeb9fd481a37c02" => :catalina
    sha256 "ab883169e2862a003dcb83292981cef2207e52d5086c25627d67844eaa94b2e8" => :mojave
    sha256 "471419a9991f35feeba9a16d51b53ec13add49c1e0a14a95323f698973883d8b" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "false"
  end
end
