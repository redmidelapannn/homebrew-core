class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://github.com/rbspy/rbspy"
  url "https://github.com/rbspy/rbspy/releases/download/v0.1.7/rbspy-v0.1.7-x86_64-apple-darwin.tar.gz"
  sha256 "58d0a1ff2c921aa3423a554188593970aab865f4e05b9b36b3cf263b023dfed8"

  bottle do
    cellar :any_skip_relocation
    sha256 "3549b347147e9d9ead552c36ed59ac481d3d398f7ae932888ab295b470df41aa" => :high_sierra
    sha256 "3549b347147e9d9ead552c36ed59ac481d3d398f7ae932888ab295b470df41aa" => :sierra
    sha256 "3549b347147e9d9ead552c36ed59ac481d3d398f7ae932888ab295b470df41aa" => :el_capitan
  end

  def install
    bin.install "rbspy"
  end

  test do
    output = shell_output("#{bin}/rbspy -V")
    assert_includes output, "rbspy"
  end
end
