class PhoronixTestSuite < Formula
  desc "Open-source automated testing/benchmarking software."
  homepage "https://www.phoronix-test-suite.com/"
  url "https://github.com/phoronix-test-suite/phoronix-test-suite/archive/v7.4.0.tar.gz"
  sha256 "beb0875ca74b62a5bb0768c337baceb3415817a6ef487dd14289ab2d84b6c504"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e9b7967be5ff26b2f9d0e29fa8b498534064861ef5d3fcb7fe35f03acc32c22" => :high_sierra
    sha256 "3e9b7967be5ff26b2f9d0e29fa8b498534064861ef5d3fcb7fe35f03acc32c22" => :sierra
    sha256 "3e9b7967be5ff26b2f9d0e29fa8b498534064861ef5d3fcb7fe35f03acc32c22" => :el_capitan
  end

  def install
    system "./install-sh", prefix
    bash_completion.install "./pts-core/static/bash_completion"
  end

  test do
    assert_match "Tynset", shell_output("#{bin}/phoronix-test-suite version | grep -v ^$")
  end
end
