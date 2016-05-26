class RubyToPython < Formula
  desc "Converts ruby to python"
  homepage "https://github.com/snood1205/ruby-to-python"
  url "https://github.com/snood1205/ruby-to-python/archive/0.0.1.tar.gz"
  sha256 "0ffbb23df844a0d18f74fb41f9f6117419557a94913307a059886e68c1f06885"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ace5906c09197c505eff01609c469547f030293c47c805930f33ac50a604599" => :el_capitan
    sha256 "f7447a1061d2769d6d53a2af9df0e2c8cb3b6c6281b6eecb29258e3031441646" => :yosemite
    sha256 "421fafd48ad5c4e151c26677f62193fddae6208b840433ae5c19c41727c252e4" => :mavericks
  end

  def install
    bin.install "r2p"
  end

  test do
    system "r2p", "ruby-to-python.rb"
  end
end
