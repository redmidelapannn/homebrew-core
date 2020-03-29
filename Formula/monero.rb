class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      :tag      => "v0.15.0.5",
      :revision => "17ec003c06eb95207c91f0e9186889f83266e461"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b603e1d1e2f317a414881021a31c2cd3365ebda6c14923db2d9429b4025f34ef" => :catalina
    sha256 "e04d614db0894659b25e6ee0b9ca0b1e2b282ebdd0710bbd209fccb938572e71" => :mojave
    sha256 "1510aa9cd69eefa3d3cc4686a2e15b3b6d85a1a39d49f5365ff99b165c8b69c9" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libsodium"
  depends_on "openssl@1.1"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  plist_options :manual => "monerod"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/monerod</string>
          <string>--non-interactive</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
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
