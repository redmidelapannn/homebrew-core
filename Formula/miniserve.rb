class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.6.0.tar.gz"
  sha256 "cad2608ff5459e5497b73b6b8635b76b0c38ce0bcee24bf4f2192984f386de93"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9c0a3b0d6d48bbbb8fcdec938742c0ff071b48a65d0e11111fe3a87538c3d9ad" => :catalina
    sha256 "276c59a1a1f340a05231a70fbca8096ada4ab53698dc1d467d846772943bf007" => :mojave
    sha256 "654118b2e9d8cae732b69efacfd8624dabbf18f7cb3fc86001a4082fe94d16ac" => :high_sierra
  end

  # Miniserve requires a known-good Rust nightly release to use.
  resource "rust-nightly" do
    url "https://static.rust-lang.org/dist/2020-03-14/rust-nightly-x86_64-apple-darwin.tar.xz"
    sha256 "6cfe5b598502d4bc6afb1bec3b1e87306d3b4057ce1ffcd8a306817c2ff5fc87"
  end

  def install
    resource("rust-nightly").stage do
      system "./install.sh", "--prefix=#{buildpath}/rust-nightly"
      ENV.prepend_path "PATH", "#{buildpath}/rust-nightly/bin"
    end
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/miniserve", "#{bin}/miniserve", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
