class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
    :tag      => "v0.9.0",
    :revision => "d14ed8fe00c38009eca840d89896af1a70060ae1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1e8c6b5f43682b18ee1c2919d050d2424fc6224d5df36e495aeeb826bbb2e98b" => :mojave
    sha256 "80a0ca48b73560b839b4aee65fe101df26ae6538bd767f807d847f3cc27caee6" => :high_sierra
    sha256 "c69985287eba4d78618b7cc89bd306dfc394e4e116d41104944390793077ae53" => :sierra
  end

  depends_on "go" => :build
  depends_on "consul" => :test

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/hashicorp/envconsul"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"envconsul"
      prefix.install_metafiles
    end
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
