class N2n < Formula
  desc "Peer-to-peer VPN"
  homepage "https://www.ntop.org/products/n2n/"
  url "https://github.com/ntop/n2n/archive/2.4.tar.gz"
  sha256 "acbf5792935b84fb6516b9a2133a0f6f70023ee6ee4ca0d2d4248cab187f3c04"

  bottle do
    cellar :any
    sha256 "43391218153a89565e5f6e53f10c1b6c0ac68dc8e9cb88992da324a69c37174c" => :mojave
    sha256 "e2b1a11666418a60ef30cdbcb56a8f2ea0b028e5d724c529141bd071cb5a206d" => :high_sierra
    sha256 "b110843593472f4624016050baa4dbf73f9a34eb97162eb5c82e7dce1ee9a876" => :sierra
  end

  depends_on "openssl"

  def install
    system "make"
    system "make", "test"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      A virtual network interface is needed. You may install one with Homebrew Cask:
        brew cask install tuntap
    EOS
  end

  test do
    system "#{sbin}/edge", "-h"
  end
end
