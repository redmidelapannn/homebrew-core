class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "http://www.vervest.org/htp/"
  url "http://www.vervest.org/htp/archive/c/htpdate-0.9.1.tar.bz2"
  sha256 "2afd132b00d33cd45eea9445387441174fe9bedf3fdf72c5a19f0051cf5a2446"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c33bb0dc7b5639f4e9d1d66cdd430b2e65ca5e16c1d91dc43cfc6d4fb6da0365" => :sierra
    sha256 "1692d10dba9b5349b2788d18b1979751abc96fd1e1a5cee253cc3c40084b1ec1" => :el_capitan
    sha256 "b564b4962c7393b93fece4d574dd3752f86b91c8f514f55f22ac667b118078c0" => :yosemite
  end

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{bin}/htpdate", "-h"
  end
end
