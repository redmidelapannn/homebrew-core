class MacosUpdate < Formula
  desc "CLI tool for handling macOS software updates"
  homepage "https://github.com/owenlejeune/macOS-update"
  url "https://github.com/owenlejeune/macOS-update/archive/v1.0.tar.gz"
  sha256 "2f01b12015f0aafead28b7b90c4dd44190d76883a09af58a6aa0f9459256b2e7"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a6576490207d063a2c72646ccd85eaaf1e635fa5ecfbf7eafa88ca59378eb55" => :mojave
    sha256 "3a6576490207d063a2c72646ccd85eaaf1e635fa5ecfbf7eafa88ca59378eb55" => :high_sierra
    sha256 "c7d54d930bce1cfdd1077b4b5c7b37a744749dedeeb4833f7b40716c479e6386" => :sierra
  end

  def install
    bin.install "macosupdate"
  end

  test do
    system "#{bin}/macosupdate", "list"
  end
end
