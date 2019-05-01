class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag      => "0.32.0",
      :revision => "6534946fe3f765bd31fc28b8aeb6c369de0b6791"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "53c8c1bd5f3208673bfeb6fc9d4aa41d3f9e124727fa05cef484d207fa3c5c2b" => :mojave
    sha256 "22778fe9c80cb1eec876b167f49368471fa306ce0e493dde8d21f69cf26e88e5" => :high_sierra
  end

  pour_bottle? do
    reason <<~EOS
      The bottle needs the [Swift 5 Runtime Support for Command Line Tools](https://support.apple.com/kb/DL1998) to be installed on macOS Mojave 10.14.3 or earlier.
        Alternatively, you can:
        * Update to macOS 10.14.4 or later
        * Install Xcode 10.2 or later at `/Applications/Xcode.app`
    EOS
    satisfy do
      MacOS.version < "10.14.0" ||
        (MacOS.version < "10.14.4" && (MacOS::Xcode.version >= "10.2" || File.directory?("/usr/lib/swift"))) ||
        MacOS.version >= "10.14.4"
    end
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "8.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: Files should have a single trailing newline. (trailing_newline)",
                 shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
                 shell_output("#{bin}/swiftlint version").chomp
  end
end
