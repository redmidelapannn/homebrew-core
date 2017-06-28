class Geo < Formula
  desc "Bash utility for network and ip geodata, with clean output for piping"
  homepage "https://github.com/jakewmeyer/Geo"
  url "https://github.com/jakewmeyer/Geo/archive/v0.1.4.tar.gz"
  sha256 "9be1ee5aa8578bd257c79c5a13503161451d8fcba19573ba41458e3a0c805801"

  bottle do
    cellar :any_skip_relocation
    sha256 "87b249356e4767f48a87fb73ec780b11ef0faf28a5e8ac0d0dbd371014d21ba1" => :sierra
    sha256 "8e932bc49a83847f6fe483e1ed46e1e9edaffed3832f67164b6ed1fcc4d3ee65" => :el_capitan
    sha256 "8e932bc49a83847f6fe483e1ed46e1e9edaffed3832f67164b6ed1fcc4d3ee65" => :yosemite
  end

  def install
    bin.install "geo"
  end

  test do
    system "#{bin}/geo", "-w"
  end
end
