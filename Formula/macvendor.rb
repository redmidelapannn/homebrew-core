class Macvendor < Formula
  desc "CLI tool which looks up a given MAC Address on macvendors.com"
  homepage "https://github.com/tuxotaku/macvendor"
  url "https://github.com/TuxOtaku/macvendor/releases/download/1.0/macvendor-darwin-amd64"
  sha256 "cb67c08ece570cdac599d87ad295e46b1a195213ecf18ad986b584e671cbf2c2"

  bottle do
    sha256 "e8e9b6fae243df2eca82c75eb8cb8f84f21f5d8cf98d6fd4660b056f9901bc96" => :high_sierra
    sha256 "e8e9b6fae243df2eca82c75eb8cb8f84f21f5d8cf98d6fd4660b056f9901bc96" => :sierra
    sha256 "e8e9b6fae243df2eca82c75eb8cb8f84f21f5d8cf98d6fd4660b056f9901bc96" => :el_capitan
  end

  def install
    bin.install "macvendor-darwin-amd64"
    system "mv #{bin}/macvendor-darwin-amd64 #{bin}/macvendor"
  end

  test do
    shell_output("#{bin}/macvendor -h", 1)
  end
end
