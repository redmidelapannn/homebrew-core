require "socket"
require "timeout"

class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router."
  homepage "https://github.com/eBay/fabio"
  url "https://github.com/eBay/fabio/archive/v1.1.6.tar.gz"
  sha256 "ae80fb63426cc26a432cd2e310f5c5dbb69a807eeef33b51fb9decb7771b0041"
  head "https://github.com/eBay/fabio.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "c26519e86623ea3f08d55d714eee5827892631e1b115b8d7b0a355a9c9b862f3" => :el_capitan
    sha256 "9e29d4a63d7aa9a5eb6a0da4fb59ec26e557ba35aee21d3a1af9d73163a35f1d" => :yosemite
    sha256 "46e0ef950f92332d7876c0878b67f725a546d972db5366cc2bc1602233a38e93" => :mavericks
  end

  devel do
    url "https://github.com/eBay/fabio/archive/v1.2rc4.tar.gz"
    sha256 "93696b6a4caf63c190426e0ce9699f4f868dd643dcf1c07eca80a49bfbd5a085"
    version "1.2rc4"
  end

  depends_on "go" => :build
  depends_on "consul" => :recommended

  def install
    mkdir_p buildpath/"src/github.com/eBay"
    ln_s buildpath, buildpath/"src/github.com/eBay/fabio"

    ENV["GOPATH"] = buildpath.to_s

    system "go", "install", "github.com/eBay/fabio"
    bin.install "#{buildpath}/bin/fabio"
  end

  test do
    require "socket"
    require "timeout"

    CONSUL_DEFAULT_PORT=8500
    FABIO_DEFAULT_PORT=9999
    LOCALHOST_IP="127.0.0.1".freeze

    def port_open?(ip, port, seconds = 1)
      Timeout.timeout(seconds) do
        begin
          TCPSocket.new(ip, port).close
          true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          false
        end
      end
    rescue Timeout::Error
      false
    end

    if !port_open?(LOCALHOST_IP, FABIO_DEFAULT_PORT)
      if !port_open?(LOCALHOST_IP, CONSUL_DEFAULT_PORT)
        fork do
          exec "consul agent -dev -bind 127.0.0.1"
          puts "consul started"
        end
        sleep 15
      else
        puts "Consul already running"
      end
      fork do
        exec "#{bin}/fabio &>fabio-start.out&"
        puts "fabio started"
      end
      sleep 5
      assert_equal true, port_open?(LOCALHOST_IP, FABIO_DEFAULT_PORT)
      system "killall", "fabio" # fabio forks off from the fork...
      system "consul", "leave"
    else
      puts "Fabio already running or Consul not available or starting fabio failed."
      false
    end
  end
end
