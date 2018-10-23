require "rbconfig"
class Lockgit < Formula
  desc "Easily store encrypted secrets in a git repo from the command-line"
  homepage "https://github.com/jswidler/lockgit"
  url "https://github.com/jswidler/lockgit/archive/v0.5.0.tar.gz"
  sha256 "5bfc50eebf7d846c1c227ffb9c92cd45e0f6c15b33316997104b5cc700ea4dfa"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c144e639341155dc0bfb08e9e13ff0d5581cdd7680e88926aa0690710146d5a" => :mojave
    sha256 "e1a8d6c043b35050f0f71d7ffdaae72b2a954e9b7a6e9aeb8dc853c769cd7270" => :high_sierra
    sha256 "d660d3b75090792a78e053e20ac125ffec1775a8c9f459ef969ed79c84919471" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"tmp/github.com/jswidler/lockgit").install buildpath.children
    mv "tmp", "src"
    cd "src/github.com/jswidler/lockgit" do
      system "make", "deps"
      system "make", "build"
      bin.install "build/lockgit"
    end
  end

  test do
    system "#{bin}/lockgit"
  end
end
