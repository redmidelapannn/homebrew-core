class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.8.23.tar.gz"
  sha256 "52161e811dcdabc5506f0dc936e7010c77116cba5f1d02a33fb81fed5bb1bf95"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c712ad8dd78c5b932b87e2a34d93892ad8887821de0aa02bf332261234ed8c00" => :mojave
    sha256 "d3b2af0bce505b8aa8fc7b5fa2edfe30bab6ce0ff7a1b798274e86284e4f3311" => :high_sierra
    sha256 "cd4022657f95a2bc1ed3783f6e6889f3a13d1665b05c03b268527e38228d74d8" => :sierra
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    bin.install Dir["build/bin/*"]
  end

  test do
    (testpath/"genesis.json").write <<~EOS
      {
        "config": {
          "homesteadBlock": 10
        },
        "nonce": "0",
        "difficulty": "0x20000",
        "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
        "coinbase": "0x0000000000000000000000000000000000000000",
        "timestamp": "0x00",
        "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "extraData": "0x",
        "gasLimit": "0x2FEFD8",
        "alloc": {}
      }
    EOS
    system "#{bin}/geth", "--datadir", "testchain", "init", "genesis.json"
    assert_predicate testpath/"testchain/geth/chaindata/000001.log", :exist?,
                     "Failed to create log file"
  end
end
