class Qhttp < Formula
  desc "Very simple http server"
  homepage "https://github.com/skyflyer/qhttp"
  url "https://github.com/skyflyer/qhttp/archive/v0.1.1.tar.gz"
  sha256 "9f62598e621da2faf40fe3dc9d1266dd5dfc21bcc054c5e45edd6b2ba3effb9d"

  bottle do
    cellar :any_skip_relocation
    sha256 "7560c38a0b960d65bd009df4c9cd9855bf3879171eca85afd16b8911dfbe6c00" => :high_sierra
    sha256 "6e9e18fc36fa64b43e175064141001f1f881d7e1a59784272c1c08c6b209a599" => :sierra
    sha256 "7690fca826b60da2fcbabab47ce49dfc99b11688f11ec5188d114e60be1e45e8" => :el_capitan
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "qhttp"
    bin.install "qhttp"
    ohai "Run 'qhttp' in a directory you wish to serve"
  end

  test do
    system "#{bin}/qhttp", "-test"
  end
end
