class Sqspush < Formula
  desc "Simple cli command that push STDIN to your AWS SQS queue"
  homepage "https://github.com/MathieuDoyon/sqspush"
  url "https://github.com/MathieuDoyon/sqspush/releases/download/0.2.1/sqspush--darwin-amd64.tar.gz"
  sha256 "3bee332c9d6cb5f69adaad924f09234250799cdc473919e516da1bc4b1120b3c"

  head "https://github.com/MathieuDoyon/sqspush.git"

  bottle do
    sha256 "5f0e9971862c6eb0395f9cd6af9b6ab193428eb6d1c50205be204e41245644a6" => :sierra
    sha256 "5f0e9971862c6eb0395f9cd6af9b6ab193428eb6d1c50205be204e41245644a6" => :el_capitan
    sha256 "5f0e9971862c6eb0395f9cd6af9b6ab193428eb6d1c50205be204e41245644a6" => :yosemite
  end

  def install
    bin.install "sqspush"
  end

  test do
    system "#{bin}/sqspush", "--help"
  end
end
