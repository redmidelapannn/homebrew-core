class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/v1.5.9.tar.gz"
  sha256 "25e3826f25fa4baf50f0a722bf080ebb47f23b5db6064e9f4af6247872f15b9d"
  head "https://github.com/fabiolb/fabio.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9d9e7df511cbfaf62efa889b360184a4a48a30d8c05e5a28877b703524929fec" => :mojave
    sha256 "a5acb93eae7badaab7b2f783881fc758d0dd13e9255e22fd31726b3332bc93a0" => :high_sierra
    sha256 "d225c04df4b718067dc017fbb585f3f360c9e67183a21f8ba5d38fc44b4f1b9b" => :sierra
    sha256 "c405e582ba18d10a2d4791a7a0460939d3cf1a021a7fc4cc1f2ce0b418e830cd" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "consul"

  def install
    mkdir_p buildpath/"src/github.com/fabiolb"
    ln_s buildpath, buildpath/"src/github.com/fabiolb/fabio"

    ENV["GOPATH"] = buildpath.to_s

    system "go", "install", "github.com/fabiolb/fabio"
    bin.install "#{buildpath}/bin/fabio"
  end

  test do
    require "socket"
    require "timeout"

    CONSUL_DEFAULT_PORT = 8500
    FABIO_DEFAULT_PORT = 9999
    LOCALHOST_IP = "127.0.0.1".freeze

    def port_open?(ip_address, port, seconds = 1)
      Timeout.timeout(seconds) do
        TCPSocket.new(ip_address, port).close
      end
      true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
      false
    end

    if !port_open?(LOCALHOST_IP, FABIO_DEFAULT_PORT)
      if !port_open?(LOCALHOST_IP, CONSUL_DEFAULT_PORT)
        fork do
          exec "consul agent -dev -bind 127.0.0.1"
          puts "consul started"
        end
        sleep 30
      else
        puts "Consul already running"
      end
      fork do
        exec "#{bin}/fabio &>fabio-start.out&"
        puts "fabio started"
      end
      sleep 10
      assert_equal true, port_open?(LOCALHOST_IP, FABIO_DEFAULT_PORT)
      system "killall", "fabio" # fabio forks off from the fork...
      system "consul", "leave"
    else
      puts "Fabio already running or Consul not available or starting fabio failed."
      false
    end
  end
end
