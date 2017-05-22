class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.18.1",
      :revision => "ab664127d5d32d9ddd655b2cc313abe528a66a42"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9b53d382e259e39a9836ff4b72e188164f88e3e44deb3fc394a5d807c38895c2" => :sierra
    sha256 "3240a555bfa1aaa8420da8c5a39ce624efa880a18950c267df5d31e5303262df" => :el_capitan
  end

  devel do
    url "https://github.com/realm/SwiftLint.git",
        :tag => "0.19.0-rc.1",
        :revision => "8ed4424a9a07f5ceae5aa7181f35f2d4f2579522"
    version "0.19.0-rc.1"
  end

  depends_on :xcode => ["7.0", :run]
  depends_on :xcode => ["8.0", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "#{testpath}/Test.swift:1: warning: Trailing Newline Violation: Files should have a single trailing newline. (trailing_newline)",
                 shell_output("SWIFTLINT_SWIFT_VERSION=3 #{bin}/swiftlint").chomp
    assert_match version.to_s,
                 shell_output("#{bin}/swiftlint version").chomp
  end
end
