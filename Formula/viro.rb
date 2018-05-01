class Viro < Formula
  desc "Command-line utility for securely managing environment variables"
  homepage "https://meshstudio.io/"
  url "https://s3.amazonaws.com/mesh-homebrew/viro"
  version "1.0.0"
  sha256 "eb22f144fe249e45332edca2a05bb40eccc81a4013b0b555915af74c1345e601"

  bottle do
    sha256 "b9d1832648a7778d87f572fed50d95ed53b7fb2f20bd2ef02d0af82e1a92c27c" => :high_sierra
    sha256 "b9d1832648a7778d87f572fed50d95ed53b7fb2f20bd2ef02d0af82e1a92c27c" => :sierra
    sha256 "b9d1832648a7778d87f572fed50d95ed53b7fb2f20bd2ef02d0af82e1a92c27c" => :el_capitan
  end

  def install
    bin.install "viro"
  end

  test do
    system bin/"viro", "--version"
    system "false"
  end
end
