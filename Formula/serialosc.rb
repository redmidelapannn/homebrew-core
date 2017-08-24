class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "http://monome.org/docs/osc/"
  url "https://github.com/monome/serialosc.git",
    :tag => "v1.4",
    :revision => "c46a0fa5ded4ed9dff57a47d77ecb54281e2e2ea"
  head "https://github.com/monome/serialosc.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8a384420c8085b99ac2e3ef339d2c50ebe7f1649aa336d0194e7c67b8afb1393" => :sierra
    sha256 "6f045d551dd7a9bfb633dd88023b67435b506eb70ca1da23f1da52944de557d4" => :el_capitan
    sha256 "1af50d027eb63f6bcccd044644951c9cd5eef742f72a66a041caf00746ae72a3" => :yosemite
  end

  depends_on "liblo"
  depends_on "confuse"
  depends_on "libmonome"

  def install
    # Upstream issue "clang 4.0.1 build failure on -Waddress-of-packed-member"
    # Reported 24 Aug 2017 https://github.com/monome/serialosc/issues/28
    if DevelopmentTools.clang_build_version >= 802
      inreplace "wscript", '"-Werror"',
                           '"-Werror", "-Wno-address-of-packed-member"'
    end

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serialosc-device -v")
  end
end
