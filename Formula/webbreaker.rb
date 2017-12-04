require "fileutils"

class Webbreaker < Formula
  desc "Webbreaker: Dynamic Application Security Test Orchestration"
  homepage "https://github.com/target/webbreaker"
  url "https://github.com/target/webbreaker/files/1512597/webbreaker-macos.zip"
  version "2.0.2"
  sha256 "f66d545cb29e2186315815ba6a8766b3f6024ca14807e46bcf807a401aea9902"

  bottle do
    cellar :any_skip_relocation
    sha256 "074f7fb2e8cf9295efc49c3cbbb61785334b6ac85620af5b57dc804638f671e3" => :high_sierra
    sha256 "074f7fb2e8cf9295efc49c3cbbb61785334b6ac85620af5b57dc804638f671e3" => :sierra
  end

  depends_on :macos => :sierra

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
