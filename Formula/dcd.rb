class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/Hackerpilot/DCD"
  url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.8.0",
      :revision => "f8f3024dda05e7f3d1a112adde1f99ec98649e78"

  head "https://github.com/Hackerpilot/dcd.git", :shallow => false

  bottle do
    rebuild 1
    sha256 "2d10a942307454485cc104ad555a2c26fce8d3d930e1714b2ce39c506e11f4bd" => :sierra
    sha256 "01276268f983f0440a9aded085079dc50d853e883d0ef2049a0079e4e23e5729" => :el_capitan
    sha256 "85fb5c541f3f63a1fc062bfedb64cb4976d9c4b1dbeb02a54857bc25bd200ea3" => :yosemite
  end

  devel do
    url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.9.0-beta.1",
      :revision => "9162b042b187f86c19b2387cfd9419db1b2806c3"
    version "0.9.0-beta.1"
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
