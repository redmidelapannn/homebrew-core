class Monero < Formula
  desc "Official monero wallet and cpu miner"
  homepage "https://getmonero.org/"
  url "https://github.com/monero-project/monero/archive/v0.12.0.0.tar.gz"
  sha256 "5e8303900a39e296c4ebaa41d957ab9ee04e915704e1049f82a9cbd4eedc8ffb"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "3be68adf510e56807fd359dc70d6e991be5469433a5ded4d0ea194a77d9f1153" => :high_sierra
    sha256 "5eb1c1238324e3e79a830c5ddb99fa3111ebc4435d0ae626416d5289441d2ab0" => :sierra
    sha256 "2f00530803641abeaf68fb9f006c45942ea92fcf8c43e2c3d656180354aaf60b" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl"
  depends_on "unbound"
  depends_on "zeromq"

  # Fix "fatal error: 'boost/thread/v2/thread.hpp' file not found"
  # https://github.com/monero-project/monero/pull/3667
  patch do
    url "https://github.com/monero-project/monero/commit/53a1962da18f952f6eb4683a846e52fe122520e2.patch?full_index=1"
    sha256 "c5869f9da9429047fdad4386d0310cd88aae499a9ff148120612ab52c5a20b74"
  end

  resource "cppzmq" do
    url "https://github.com/zeromq/cppzmq/archive/v4.2.3.tar.gz"
    sha256 "3e6b57bf49115f4ae893b1ff7848ead7267013087dc7be1ab27636a97144d373"
  end

  def install
    (buildpath/"cppzmq").install resource("cppzmq")
    system "cmake", ".", "-DZMQ_INCLUDE_PATH=#{buildpath}/cppzmq", *std_cmake_args
    system "make", "install"
  end

  test do
    cmd = "yes '' | #{bin}/monero-wallet-cli --restore-deterministic-wallet " \
      "--password brew-test --restore-height 1 --generate-new-wallet wallet " \
      "--electrum-seed 'baptism cousin whole exquisite bobsled fuselage left " \
      "scoop emerge puzzled diet reinvest basin feast nautical upon mullet " \
      "ponies sixteen refer enhanced maul aztec bemused basin'" \
      "--command address"
    address = "4BDtRc8Ym9wGzx8vpkQQvpejxBNVpjEmVBebBPCT4XqvMxW3YaCALFraiQibejyMAxUXB5zqn4pVgHVm3JzhP2WzVAJDpHf"
    assert_equal address, shell_output(cmd).lines.last.split[1]
  end
end
