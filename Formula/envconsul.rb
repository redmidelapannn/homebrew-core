class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
    :tag      => "v0.9.2",
    :revision => "e00ce74043ac1204566ece60f12919c8b56467f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c6124368ea055ecca7e5b75484ed0da40b3de0c86c43e9188c0b00447e9b52b" => :catalina
    sha256 "a0488492fac09bc1f89a224264602505e3fa7fda8747614ba8a40df5566cd77a" => :mojave
    sha256 "418b4cc14d268c77074fb118cafe2165a1d4eab9b74489647328328b97d5327d" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "consul" => :test

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"envconsul"
    prefix.install_metafiles
  end

  test do
    require "socket"
    require "timeout"

    CONSUL_DEFAULT_PORT = 8500
    LOCALHOST_IP = "127.0.0.1".freeze

    def port_open?(ip_address, port, seconds = 1)
      Timeout.timeout(seconds) do
        TCPSocket.new(ip_address, port).close
      end
      true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
      false
    end

    begin
      if !port_open?(LOCALHOST_IP, CONSUL_DEFAULT_PORT)
        fork do
          exec "consul agent -dev -bind 127.0.0.1"
          puts "consul started"
        end
        sleep 5
      else
        puts "Consul already running"
      end
      system "consul", "kv", "put", "homebrew-recipe-test/working", "1"
      output = shell_output("#{bin}/envconsul -consul-addr=127.0.0.1:8500 -upcase -prefix homebrew-recipe-test env")
      assert_match "WORKING=1", output
    ensure
      system "consul", "leave"
    end
  end
end
