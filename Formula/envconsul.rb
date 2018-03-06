class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul/archive/v0.7.3.tar.gz"
  sha256 "7152d73818c3faceac831c6ffae6e01c2f3a6372976409d9d084130ffcea35f4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bee71d33582c1c4567e978258d705bc55875b388a93fe54309a4886bb2a2617e" => :high_sierra
    sha256 "06c1b30b8bde7509256d27d011865cb179eff5490d4cae144ef5aad83ffe7687" => :sierra
    sha256 "788af35307e2d051c9a5e3ef04acb6fb735237d9a826ecd2a4356e60034ae878" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "consul" => :recommended # only used in test

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/hashicorp/envconsul").install buildpath.children
    cd "src/github.com/hashicorp/envconsul" do
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
