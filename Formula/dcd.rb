class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/Hackerpilot/DCD"
  url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.8.0",
      :revision => "f8f3024dda05e7f3d1a112adde1f99ec98649e78"

  head "https://github.com/Hackerpilot/dcd.git", :shallow => false

  bottle do
    revision 1
    sha256 "c6b223a4b9bcd6f63331a85ace6a217c1605269baf8090645c305b396b6b221f" => :el_capitan
    sha256 "ab98b6100b593b0a1cc5fc265a17e16b03735822277a3e1363f42d3203a36a48" => :yosemite
    sha256 "0ba417fbda36d2fd26fd37f98b02b0098b8af3c7cbf160dba563c1d4d76cc319" => :mavericks
  end

  devel do
    url "https://github.com/Hackerpilot/DCD.git",
      :tag => "v0.9.0-alpha4",
      :revision => "c324ca9700d7ed9cf2f89c140b286ae9f325b977"
    version "0.9.0-alpha4"
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
