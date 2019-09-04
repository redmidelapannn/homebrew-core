class Outliner < Formula
  desc "CLI tool for Auto setup and deploy outline VPN"
  homepage "https://github.com/Jyny/outliner"
  head "https://github.com/Jyny/outliner.git"
  url "https://github.com/Jyny/outliner/archive/v0.1.4.tar.gz"
  sha256 "7c7e3511fee130a9bd090300cf4827fc7d592281d4226a5c83cb63b75a2351d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "c67c325b5027a64a1bff19618b75ab561f207cdc96e8567caa6bdbf80521f9ca" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make"
    system "mv build/outliner_$(go env GOOS) ./outliner"
    bin.install "outliner"
  end

  test do
    assert_match "outliner", shell_output("#{bin}/outliner")
  end
end
