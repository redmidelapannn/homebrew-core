class Cdecl < Formula
  desc "Compose and decipher C (or C++) type declarations or casts."
  homepage "https://github.com/paul-j-lucas/cdecl"
  url "https://github.com/paul-j-lucas/cdecl/releases/download/cdecl-3.0.1/cdecl-3.0.1.tar.gz"
  sha256 "68437d334f1392f2e0555ae65cc9de5e13d8f9d13f9363e893c90d9654e11e37"

  bottle do
    cellar :any_skip_relocation
    sha256 "4214528509850edf1d81130b2c681f97e5c8ee36243a377f23bd69e782376de7" => :sierra
    sha256 "449a3d108f5f3726fd267ae3e39c825b1434b7442b2acfebec186a61d8e43091" => :el_capitan
    sha256 "7356439149568e085429a7db3372d332b0a0cca2b433cf68b502c8f4a213934b" => :yosemite
  end

  def install
    ENV.deparallelize # must ensure parser.h builds first

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "declare p as pointer to int",
                 shell_output("#{bin}/cdecl explain 'int *p'").strip
  end
end
