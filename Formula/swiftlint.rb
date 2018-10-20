class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.27.0",
      :revision => "12996ef1f54002e5daa45148944ad9219dacef8a"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a8158a7d305a43ffd4cdfd408c569d049536828314df9a074310f28ccd485925" => :mojave
    sha256 "c07a9c8a2f4e00f263236bd1b2b0209e8797681a6f2d1e69dc6a328980c316d2" => :high_sierra
    sha256 "1bf6be64b83af49a71bc03a8d4f6f8b37ef226c65d3f97cfb46962deefbcef28" => :sierra
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
