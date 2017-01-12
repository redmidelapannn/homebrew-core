class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.16.0",
      :revision => "ed7209cb459b00ba6cb82ca4bfb81fa1690e84a9"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "828b4f80cdf500373da13e74b4065b8822aa990fd5134c70ac1472ed792752c1" => :sierra
    sha256 "3b1f97727e242b8007237f682282ff3906c7373025c2f0b696e1cc533529b5b4" => :el_capitan
  end

  depends_on :xcode => "8.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/swiftlint", "version"
  end
end
