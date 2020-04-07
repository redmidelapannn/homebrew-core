class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
    :tag      => "v0.9.2",
    :revision => "e00ce74043ac1204566ece60f12919c8b56467f3"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c873816c1ce5f657ea124a00c53989d0108b9178e7472b1468a5dfff00d37fc3" => :catalina
    sha256 "0e31c2257b8b65acaa43cdd6788fec989e62dc2205ea52e1bae11fe97d16d005" => :mojave
    sha256 "3b6eaf563b4652a612b9da5eb1a4c67259c011e4ca048ebc6a9283f542a771fe" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "consul" => :test

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"envconsul"
    prefix.install_metafiles
  end

  test do
    port = free_port
    begin
      fork do
        exec "consul agent -dev -bind 127.0.0.1 -http-port #{port}"
        puts "consul started"
      end
      sleep 5

      system "consul", "kv", "put", "-http-addr", "127.0.0.1:#{port}", "homebrew-recipe-test/working", "1"
      output = shell_output("#{bin}/envconsul -consul-addr=127.0.0.1:#{port} " \
                            "-upcase -prefix homebrew-recipe-test env")
      assert_match "WORKING=1", output
    ensure
      system "consul", "leave", "-http-addr", "127.0.0.1:#{port}"
    end
  end
end
