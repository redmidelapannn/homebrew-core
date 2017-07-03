class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag => "v0.9.0",
      :revision => "27a3f8a76346cb988473bfe67f4947db7dd7bc71"

  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    rebuild 1
    sha256 "7c00dea9e81f0892df40aacc047b997b4c1f665bf2c25ac6df348b5f601e2306" => :sierra
    sha256 "eb86ae0f7b6fbf80f61b48479fe71a3eb5590dab8778961d8e89b059f6d94df9" => :el_capitan
    sha256 "2e603e6605e42bc1508af976f9b7b241ded3ac8a796c804ed91faf34eab60c26" => :yosemite
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
