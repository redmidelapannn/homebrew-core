class Bartycrouch < Formula
  desc "Incrementally update your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch/archive/3.11.0.tar.gz"
  sha256 "fcae8593020a3302f2247abfafbf9024efb1561233cd3be2aec6fb795546059b"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e58e7988181732f0c2cc2ecc5e8edc83f14fe50ad42ff2ffd4e83b9eb6cca04" => :high_sierra
    sha256 "728a38134a393a089041732405bc44b41e7149c0ea4f67f8159d67a184cff55a" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

  def install
    xcodebuild "-project", "BartyCrouch.xcodeproj",
               "-scheme", "BartyCrouch CLI",
               "SYMROOT=build",
               "DSTROOT=#{prefix}",
               "INSTALL_PATH=/bin",
               "-verbose",
               "install"
  end

  test do
    (testpath/"Test.swift").write <<~EOS
      import Foundation

      class Test {
        func test() {
            NSLocalizedString("test", comment: "")
        }
      }
    EOS

    (testpath/"en.lproj/Localizable.strings").write <<~EOS
      /* No comment provided by engineer. */
      "oldKey" = "Some translation";
    EOS

    system bin/"bartycrouch", "code", "-p", testpath, "-l", testpath, "-a"
    assert_match /"oldKey" = "/, File.read("en.lproj/Localizable.strings")
    assert_match /"test" = "/, File.read("en.lproj/Localizable.strings")
  end
end
