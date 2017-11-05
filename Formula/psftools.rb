class Psftools < Formula
  desc "Tools for fixed-width bitmap fonts"
  homepage "https://www.seasip.info/Unix/PSF/"
  url "https://www.seasip.info/Unix/PSF/psftools-1.0.7.tar.gz"
  sha256 "d6f83e76efddaff86d69392656a5623b54e79cfe7aa74b75684ae3fef1093baf"

  bottle do
    cellar :any
    rebuild 1
    sha256 "df4d3a43f1fa8bf5364b9c003afe4865cb88a51c551f35ab9df96d8fa452e687" => :high_sierra
    sha256 "b952791127ca6890e438fe8511cff87d2e8b18f708ff2e79ac29465a96c3483b" => :sierra
    sha256 "cd492dfb08f8b8249c6c0cad185a7c189fa592ccc38394471ebd3c2ac5da8f34" => :el_capitan
  end

  depends_on "autoconf" => :build

  resource "pc8x8font" do
    url "https://www.zone38.net/font/pc8x8.zip"
    sha256 "13a17d57276e9ef5d9617b2d97aa0246cec9b2d4716e31b77d0708d54e5b978f"
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    # The zip file has a fon in it, use fon2fnts to extrat to fnt
    resource("pc8x8font").stage do
      system "#{bin}/fon2fnts", "pc8x8.fon"
      assert_predicate Pathname.pwd/"PC8X8_9.fnt", :exist?
    end
  end
end
