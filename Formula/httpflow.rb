class Httpflow < Formula
  desc "Packet capture and analysis utility similar to tcpdump for HTTP"
  homepage "https://github.com/six-ddc/httpflow"
  url "https://github.com/six-ddc/httpflow/archive/0.0.5.tar.gz"
  sha256 "a20b12243bcdd4ac8c8c14706cb508ec36aceea72e1fff2892777783b8441e46"
  head "https://github.com/six-ddc/httpflow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b4dbfc96c37e8f30928e352728772087efa6dca47cd247c147935e43fb654c3" => :sierra
    sha256 "951cf6c2d8b5b6ee2ec7a87f8b0417538f7b5c636d977469bfb6bf2860959e9a" => :el_capitan
    sha256 "d3a36188b0b53585223b5df7cf76b2d6df5e9639310aaa572a341a3d56bd837c" => :yosemite
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}", "CXX=#{ENV.cxx}"
  end

  test do
    system "#{bin}/httpflow", "-h"
  end
end
