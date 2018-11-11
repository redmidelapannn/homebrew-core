class Frobtads < Formula
  desc "TADS interpreter and compilers"
  homepage "https://www.tads.org/frobtads.htm"
  url "https://github.com/realnc/frobtads/releases/download/1.2.4/frobtads-1.2.4.tar.bz2"
  sha256 "705be5849293844f499a85280e793941b0eacb362b90d49d85ae8308e4c5b63c"

  bottle do
    rebuild 1
    sha256 "47c2d9ff6c36acae2bf4ed2fd103e8b4f74801a01f5453abf2cf14ec3e5c75e5" => :mojave
    sha256 "1b3f79a5748b74d9f8239ad2c2059525fff5afc09e69ac8ca9df5574ddf0e2dd" => :high_sierra
    sha256 "1d5963a78c5abe23d535ef0d4a3122031b906e02478f2a32bfe608fe67a42e79" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /FrobTADS #{version}$/, shell_output("#{bin}/frob --version")
  end
end
