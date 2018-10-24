class Terminus < Formula
  desc "Standalone utility for performing operations on the Pantheon Platform"
  homepage "https://github.com/pantheon-systems/terminus"
  url "https://github.com/pantheon-systems/terminus/archive/1.9.0.tar.gz"
  sha256 "4e315e950affbf0c95e7b1225b80151c85ff8ae04b2aad053c2adb5c30380f93"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6419319ae5f6103f5596b42f582fd6834215f32896c19ee5baaf2456e2b2467" => :mojave
    sha256 "f0c5f1d59679cdf94dd74f50f0645f1ca5ac91dfa9b7ee14b26f5d86d477b6d2" => :high_sierra
    sha256 "32c1a134533445345a06052a657ed5029fd95b1cd64ab9a1f08c347e9521436c" => :sierra
  end

  depends_on "composer"

  def install
    system "composer", "install"
    bin.install "bin/terminus" => "terminus"
    prefix.install "composer.json", "composer.lock", "assets", "src", "vendor", "config"
  end

  test do
    assert_match "commands", shell_output("#{bin}/terminus list")
  end
end
