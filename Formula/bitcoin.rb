class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://bitcoin.org/bin/bitcoin-core-0.16.0/bitcoin-0.16.0.tar.gz"
  sha256 "8cbec0397d932cab7297a8c23c918392f6eebd410646b4b954787de9f4a3ee40"

  bottle do
    cellar :any
    rebuild 1
    sha256 "77a4e68d322e5f4ded95a48cfb158d570fe4e028be91984186290516022b6f76" => :high_sierra
    sha256 "31220c226b0b134cc3de56f398482e65f7300b7e56bb10870c0082b7b397cad1" => :sierra
    sha256 "82215413671543e9a1e559d2126896172100739ce55cb22c8dacdaccb020029f" => :el_capitan
  end

  head do
    url "https://github.com/bitcoin/bitcoin.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on "miniupnpc"
  depends_on "openssl"
  depends_on "zeromq"

  needs :cxx11

  def install
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? &&
       MacOS::Xcode.version >= "8.0"
      ENV.delete("SDKROOT")
    end

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "share/rpcauth"

    # Additionally add a testnet executable to run bitcoind testnet daemon
    plist_path(testnet = true).write testnet_plist
    plist_path(testnet = true).chmod 0644
  end

  plist_options :manual => "bitcoind"

  # Override Formula#plist_name
  def plist_name(testnet = false)
    testnet ? super() + "-testnet" : super()
  end

  # Override Formula#plist_path
  def plist_path(testnet = false)
    testnet ? super().dirname + (plist_name(true) + ".plist") : super()
  end

  def testnet_plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name(testnet = true)}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/bitcoind</string>
        <string>-testnet</string>
        <string>-conf=~/Library/Application Support/Bitcoin/testnet3/bitcoin.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/bitcoind</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/test_bitcoin"
  end
end
