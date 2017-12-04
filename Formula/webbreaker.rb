require "fileutils"

class Webbreaker < Formula
  desc "Webbreaker: Dynamic Application Security Test Orchestration"
  homepage "https://github.com/target/webbreaker"
  url "https://github.com/target/webbreaker/files/1512597/webbreaker-macos.zip"
  version "2.0.2"
  sha256 "f66d545cb29e2186315815ba6a8766b3f6024ca14807e46bcf807a401aea9902"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f1dec54d6fd1bf688507f1b17ffbf327ae97e38f07477476470263da4ced204" => :high_sierra
    sha256 "0f1dec54d6fd1bf688507f1b17ffbf327ae97e38f07477476470263da4ced204" => :sierra
    sha256 "0f1dec54d6fd1bf688507f1b17ffbf327ae97e38f07477476470263da4ced204" => :el_capitan
  end

  def install
    bin.install "webbreaker-macos"
    mv("#{bin}/webbreaker-macos", "#{bin}/webbreaker")
    bin.install_symlink "#{bin}/webbreaker" "webbreaker"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "#{bin}/webbreaker", "--help"
  end
end
