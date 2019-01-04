class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.9.0.tar.gz"
  sha256 "4ce9c118cf5da1159a882dea389f3c5737b5d98192e9a619b0fe8c1730341cc6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c3c5bb54b826028ba81220ef1b7b95dc3b24cf5052c03d6d9823f223c092f968" => :mojave
    sha256 "046af2ce296e01d2c47d0e10e6762d87c303743b65f68b47baad80cb5e785946" => :high_sierra
    sha256 "914a83043bf8527127462fab799a9eefdf2f9e623b74246fe87d3f202aa0cca3" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "doc/bat.1"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
