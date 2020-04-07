class Sslsplit < Formula
  desc "Man-in-the-middle attacks against SSL encrypted network connections"
  homepage "https://www.roe.ch/SSLsplit"
  url "https://github.com/droe/sslsplit/archive/0.5.5.tar.gz"
  sha256 "3a6b9caa3552c9139ea5c9841d4bf24d47764f14b1b04b7aae7fa2697641080b"
  revision 1
  head "https://github.com/droe/sslsplit.git", :branch => "develop"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b2031972883c3d6246d63362564ee769e482cd90ca1d46aa565069df0d6e59d4" => :catalina
    sha256 "be118edf9fde05777b841cc27f27f64fd1dc664b7352e7c8cd71296835d8f827" => :mojave
    sha256 "cc9d8f71762641de58da6cd64d6120b4088cb147e6bcff5bc82957c91db22901" => :high_sierra
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libnet"
  depends_on "libpcap"
  depends_on "openssl@1.1"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    port = free_port

    cmd = "#{bin}/sslsplit -D http 0.0.0.0 #{port} www.roe.ch 80"
    output = pipe_output("(#{cmd} & PID=$! && sleep 3 ; kill $PID) 2>&1")
    assert_match "Starting main event loop", output
  end
end
