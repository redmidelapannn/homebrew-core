class Taskell < Formula
  desc "Command-line kanban board/task manager written in Haskell"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.1.0.tar.gz"
  sha256 "77ad4aaeb1121445f2f6f7553d75e0c1fa47734ac3089c4595b8ba1d27b9b126"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfdaad2e490e10e72b624f33d226a1d5ee4f8f83bfdfa14d85792bf95879b41e" => :high_sierra
    sha256 "db3204c84beb134ca3bb5e8fad111c82836938867d542d3651e9ca6172f825b7" => :sierra
    sha256 "cf58d5533816dfb88d450585e73a7c5e65801d16f4f15d00783654516ead94e1" => :el_capitan
  end

  depends_on "haskell-stack" => :build

  def install
    system "stack", "build"
    system "stack", "install", "--local-bin-path=#{bin}"
  end

  test do
    system "#{bin}/taskell", "-v"
  end
end
