class Swiftformat < Formula
  desc "Formatting tool for Swift source code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.17.tar.gz"
  sha256 "68cfc0f783ca331a1fda1c8b5c5a670b6c42be72a44a34b519d61d308b2fe8ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b8fbc16e925768ff3414711ada51d0537c870874c4deb6473a2c8a4e6a75905" => :sierra
    sha256 "1b8fbc16e925768ff3414711ada51d0537c870874c4deb6473a2c8a4e6a75905" => :el_capitan
    sha256 "1b8fbc16e925768ff3414711ada51d0537c870874c4deb6473a2c8a4e6a75905" => :yosemite
  end

  def install
    bin.install "CommandLineTool/swiftformat"
  end

  test do
    system "#{bin}/swiftformat"
  end
end
