class Gti < Formula
  desc "ASCII-art displaying typo-corrector for commands"
  homepage "https://r-wos.org/hacks/gti"
  url "https://github.com/rwos/gti/archive/v1.6.1.tar.gz"
  sha256 "6dd5511b92b64df115b358c064e7701b350b343f30711232a8d74c6274c962a5"
  head "https://github.com/rwos/gti.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f2e4c620920e991d416af3206874c2f49a1203bf27a7ab9d08ed6bff075c99c2" => :mojave
    sha256 "e0d6fae64565222057db46e9c807f3ab6c7261dab7bc99d50decb3d43cc7f4ae" => :high_sierra
    sha256 "22f9a7458b4d790a14504739d311e125791ba146add6a7f0654b1b5e9c0ec3f3" => :sierra
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "gti"
    man6.install "gti.6"
  end

  test do
    system "#{bin}/gti", "init"
  end
end
