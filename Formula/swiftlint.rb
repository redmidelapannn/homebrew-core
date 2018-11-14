class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag      => "0.28.0",
      :revision => "94dd8b4772c3158b83e7ac8cd0ab538d657badba"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8ac3927adc00bbfb2f1a3bcd7b0322110db97a86eed7179fa31cf5d79ab4777" => :mojave
    sha256 "4d3f1433e96aa4e5ad7a175ebdd1d7807b2397601ba670776ad9c8196161f9dd" => :high_sierra
    sha256 "686d39026e3c3cf183437646d9d8fc54b8faa9b6743980ad273c345238d41635" => :sierra
  end

  depends_on :xcode => ["9.0", :build]
  depends_on :xcode => "8.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1: warning: Trailing Newline Violation: Files should have a single trailing newline. (trailing_newline)",
                 shell_output("SWIFTLINT_SWIFT_VERSION=3 #{bin}/swiftlint --no-cache").chomp
    assert_match version.to_s,
                 shell_output("#{bin}/swiftlint version").chomp
  end
end
