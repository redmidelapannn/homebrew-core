class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code."
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.5.9.tar.gz"
  sha256 "1f5dee5184a7271a70552c0e85dd1d730e711088e5fdcf3dd7aa1f96b993e414"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6d0cfcf881e96fe10f6744304fb0d8d441aa3bab1287794e08e40567ae99366a" => :sierra
    sha256 "747cbf8707110c67beec2dc9daa273eb7732f20d06126cf6e522ac59b79cc43f" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

  def install
    rake "build"
    inreplace "bin/sourcery", '"${parent_path}"', libexec
    bin.install "bin/sourcery"
    libexec.install "bin/Sourcery.app"
  end

  test do
    # Tests are temporarily disabled because of sandbox issues,
    # as Sourcery tries to write to ~/Library/Caches/Sourcery
    # See https://github.com/krzysztofzablocki/Sourcery/pull/133
    #
    # Remove this test once the PR has been merged and been tagged with a release
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp

    # Re-enable these tests when the issue has been closed
    #
    # (testpath/"Test.swift").write <<-TEST_SWIFT
    # enum One { }
    # enum Two { }
    # TEST_SWIFT
    #
    # (testpath/"Test.stencil").write <<-TEST_STENCIL
    # // Found {{ types.all.count }} Types
    # // {% for type in types.all %}{{ type.name }}, {% endfor %}
    # TEST_STENCIL

    # system "#{bin}/sourcery", testpath/"Test.swift", testpath/"Test.stencil", testpath/"Generated.swift"

    # expected = <<-GENERATED_SWIFT
    # // Generated using Sourcery 0.5.3 - https://github.com/krzysztofzablocki/Sourcery
    # // DO NOT EDIT
    #
    #
    # // Found 2 Types
    # // One, Two,
    # GENERATED_SWIFT
    # assert_match expected, (testpath/"Generated.swift").read, "sourcery generation failed"
  end
end
