class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/Hackerpilot/DCD"
  url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.8.0",
      :revision => "f8f3024dda05e7f3d1a112adde1f99ec98649e78"

  head "https://github.com/Hackerpilot/dcd.git", :shallow => false

  bottle do
    rebuild 1
    sha256 "bc73677c3d7c132f8eab62459bf9f5d32ff07517d38be56a36772a53993094e7" => :sierra
    sha256 "73301ff2c5daa1954771e5d4379d8ca47fadec0cd2f55e4deaf1f07dcfdb2782" => :el_capitan
    sha256 "fa255cbd7d6b424517f40800d0821692db25771f3a19fe4b305b331b6441988f" => :yosemite
  end

  devel do
    url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.9.0-alpha5",
      :revision => "83454f10f49da2c95b366206934cf3a88f8ce3f4"
    version "0.9.0-alpha5"
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
