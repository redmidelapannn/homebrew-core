class Lv2 < Formula
  desc "Portable plugin standard for audio systems"
  homepage "https://lv2plug.in/"
  url "https://lv2plug.in/spec/lv2-1.16.0.tar.bz2"
  sha256 "dec3727d7bd34a413a344a820678848e7f657b5c6019a0571c61df76d7bdf1de"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "efd4e606efc1496c921907362b5ec51bfb2b8275ec91d174e93d9da6a7ef7a90" => :catalina
    sha256 "efd4e606efc1496c921907362b5ec51bfb2b8275ec91d174e93d9da6a7ef7a90" => :mojave
    sha256 "efd4e606efc1496c921907362b5ec51bfb2b8275ec91d174e93d9da6a7ef7a90" => :high_sierra
  end

  depends_on :macos # Due to Python 2

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--no-plugins", "--lv2dir=#{lib}"
    system "./waf", "build"
    system "./waf", "install"
  end
end
