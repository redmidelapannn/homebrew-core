class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/Hackerpilot/DCD"
  url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.8.0",
      :revision => "f8f3024dda05e7f3d1a112adde1f99ec98649e78"

  head "https://github.com/Hackerpilot/dcd.git", :shallow => false

  bottle do
    rebuild 1
    sha256 "b68cfc612f3ba2d07a3d6e59ceadedf22369648aa7eb8019e6fc0b5c013f3a93" => :sierra
    sha256 "49956773182676fc56f6aaefc794e6a6d6606ebec3c4057de442c944c29835f5" => :el_capitan
    sha256 "ca3675e6bad0908f36cc9835bf61d69dc292801e8144021cfe20e73a0deaadb4" => :yosemite
  end

  devel do
    url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.9.0-alpha.6",
      :revision => "b5d313922317ff25d3a39980af248b7eff19b93b"
    version "0.9.0-alpha6"
  end

  depends_on "dmd" => :build

  def install
    if build.stable?
      rmtree "libdparse/experimental_allocator"
      rmtree "containers/experimental_allocator"
    end
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
