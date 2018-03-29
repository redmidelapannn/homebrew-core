class Balance < Formula
  desc "Software load balancer"
  homepage "https://www.inlab.de/balance.html"
  url "https://www.inlab.de/balance-3.57.tar.gz"
  sha256 "b355f98932a9f4c9786cb61012e8bdf913c79044434b7d9621e2fa08370afbe1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c31953aa7c1e2e0c1a20ebde894c0147f516a4e4ae2c08d0ca7a751b5ee00b5c" => :high_sierra
    sha256 "2da459b4a7ab1d4fc0e21f82c5eb8ee9e1892f1773b9928e9a75170d9522bb15" => :sierra
    sha256 "8b32891aa4c8fe707e6b706e93e865419a713754318ec91d40f0caba5404fe8a" => :el_capitan
  end

  def install
    system "make"
    bin.install "balance"
    man1.install "balance.1"
  end

  test do
    output = shell_output("#{bin}/balance 2>&1", 64)
    assert_match "this is balance #{version}", output
  end
end
