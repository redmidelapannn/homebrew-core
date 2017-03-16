class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/0.99.2.tar.gz"
  sha256 "f2eeec1b8d8626756f2cb9c461e9d1db20affccf582d43ded439bdb2d12646ef"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "418c98898809c4e1590aeb8c4b5e60b65d6ca579a4bd2fa340743847bf4e216a" => :sierra
    sha256 "54d9a3b9045125e2b8c4abce53966d67e859f6ae152e501961de683ad5117aea" => :el_capitan
    sha256 "2171e1d2666b8cf15132f2b134b1a555e889651c8144ecdc9832cba49431625a" => :yosemite
  end

  patch do
    url "https://github.com/pbiering/ipv6calc/commit/128cb3b178dde1b9bcadc1b7a334c5eebcc529be.patch"
    sha256 "3148380d4aba3b50150597ec209a1cf7aca7091d3be5f57a2e517445cb55430c"
  end

  def install
    # This needs --mandir, otherwise it tries to install to /share/man/man8.
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97", shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
