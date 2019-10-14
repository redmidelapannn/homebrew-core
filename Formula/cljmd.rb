class Cljmd < Formula
  desc "Clojure for Automation Scripting and CLI Tools"
  homepage "https://github.com/axrs/cljmd"
  url "https://github.com/axrs/cljmd/archive/v0.0.4.tar.gz"
  sha256 "27dad0df4ff240c2edf6a85424ba395b941996e6d728dc2d12ad7d7e00cb657a"

  bottle do
    cellar :any_skip_relocation
    sha256 "b64564a31f0db36c6b3a169840e1c3abb01592e4c7c4c87d6cd1391b0cee1a54" => :catalina
    sha256 "b64564a31f0db36c6b3a169840e1c3abb01592e4c7c4c87d6cd1391b0cee1a54" => :mojave
    sha256 "b64564a31f0db36c6b3a169840e1c3abb01592e4c7c4c87d6cd1391b0cee1a54" => :high_sierra
  end

  depends_on "clojure"

  def install
    bin.install "cljmd"
  end
end
