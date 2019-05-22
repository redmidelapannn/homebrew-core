class Sail < Formula
  desc "The universal standard for instant, pre-configured dev environments"
  homepage "https://sail.dev"
  url "https://github.com/cdr/sail/archive/v1.0.1.tar.gz"
  sha256 "1fb1fe562894365ac9bd224a1e5ca781bfdb34917afe13af21ee8d526434dc5c"
  bottle do
    cellar :any_skip_relocation
    sha256 "c2f6d944cc5bcc380ff0abfd3e84357d982bab033ed6fb35e8b39ede0f19877e" => :mojave
    sha256 "db971e4ab10429edfda3341c3b899d6896d308ba4520d189ff10fa7b0880aad8" => :high_sierra
    sha256 "2593fc7cf8e9e8a775475f42aa55cbefb315ae74f94f4422ba592d0063a2d5b1" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bin/sail", "."
    bin.install "bin/sail" => "sail"
  end

  def caveats; <<~EOS
    You will need docker to use sail.
    Please install via:

      brew cask install docker
  EOS
  end

  test do
    output = `#{bin}/sail --help 2>&1`
    output.include? "A utility for managing Docker-based code-server environments."
  end
end
