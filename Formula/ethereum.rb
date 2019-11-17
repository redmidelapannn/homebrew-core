class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.9.7.tar.gz"
  sha256 "991ab9cad1697e32acf0f926e38e8d4f6ee3140d3f3236f971b178a6a35a187b"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b2d1250b58077d4db47f88c860d738cb6fc699b5e6ab9a330042b9d68b52793b" => :catalina
    sha256 "87298e7f860f54b8b8f36209643f0786073917f4250336049cb56b3937325f4b" => :mojave
    sha256 "51fde67ca292be4c0788e1cdb02041ae0ae713d1d5dcf2fc9460d2119d0ec2dc" => :high_sierra
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
