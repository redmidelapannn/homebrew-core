class AwsRunas < Formula
  desc "Friendly way to do AWS STS AssumeRole operations"
  homepage "https://github.com/mmmorris1975/aws-runas/"
  url "https://github.com/mmmorris1975/aws-runas/archive/1.3.4.tar.gz"
  sha256 "4b1e3fe48e470d0705c0d3064aaa0fbb32086976b007137478e5a8499053ab77"

  bottle do
    cellar :any_skip_relocation
    sha256 "17b39a0fb0d3e2a10db2a4c48988f1eed695a5bfbac7cb5fde4790327a422a97" => :mojave
    sha256 "e8dfa2238e6f15d49ad72237205fd276954349842769fc37f1b77c501ca50cbe" => :high_sierra
    sha256 "e3487df57b1f29165df883f3e5bd0d9b6d02ef999fcc1220cebc063732ed6986" => :sierra
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "aws-runas"
  end

  test do
    system bin/"aws-runas", "--help"
  end
end
