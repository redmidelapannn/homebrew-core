class Disque < Formula
  desc "Disque, an in-memory, distributed job queue"
  homepage "https://github.com/antirez/disque"
  url "https://github.com/antirez/disque/archive/1.0-rc1.tar.gz"
  version "1.0-rc1"
  sha256 "2d6fc85d16c8009154fc24d7fb004708f864712853d417cbea74bb6c2694e134"

  bottle do
    cellar :any_skip_relocation
    sha256 "069a72fb61059c25995ac8c8ad80aff1ee865916a20c8c90a655517aaeb35f07" => :el_capitan
    sha256 "d8190e1fbfbb1a06fae3039aea308c8a99b5e3874151b553ab4c0309d1be65cc" => :yosemite
    sha256 "2a61f1fe98a0ba80b12f9c0a116e7c72cea5d8da702294797adf5c913f2b845b" => :mavericks
  end

  def install
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/disque-server", "--test-memory", "2"
  end
end
