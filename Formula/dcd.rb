class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag      => "v0.10.1",
      :revision => "21f273abfb813edd782614faf7e0b5fa043e9c68"
  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "921aae47aa24ad431a5e5e2c128c2be01065ad08be1ce0e2fe33da5fa7a8c13e" => :mojave
    sha256 "4308b5e9a5c29c61db0ee62100cbb089f494c497ab28340ba21bb3518b89db0d" => :high_sierra
    sha256 "d5ef4f81734e79f53c1f9fe0a75c5006ed6d15ba0f59e67f73b9e0d083e4c4fd" => :sierra
  end

  depends_on "dmd" => :build

  def install
    system "make"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    begin
      # spawn a server, using a non-default port to avoid
      # clashes with pre-existing dcd-server instances
      server = fork do
        exec "#{bin}/dcd-server", "-p9167"
      end
      # Give it generous time to load
      sleep 0.5
      # query the server from a client
      system "#{bin}/dcd-client", "-q", "-p9167"
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
