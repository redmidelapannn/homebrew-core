class Pldiff < Formula
  desc "Compares plist files line by line"
  homepage "https://github.com/scottrigby/pldiff"
  url "https://github.com/scottrigby/pldiff/archive/1.0.4.tar.gz"
  sha256 "0093027aee4ceb049902a9fcea28923477c87c2f88813e2370fb4c12195b9ccd"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4c1bacfccd6f5d9a8bf89d5a7f0741574ca59be4b0d120ab9de4ab74cf18513" => :sierra
    sha256 "c33c8d9f0ec71850a56a1af808bf78347002800ee74f27689663f5e21812f475" => :el_capitan
    sha256 "c33c8d9f0ec71850a56a1af808bf78347002800ee74f27689663f5e21812f475" => :yosemite
  end

  depends_on "colordiff" => :recommended

  def install
    system "/bin/sh", "install.sh", prefix
  end

  test do
    system "false"
  end
end
