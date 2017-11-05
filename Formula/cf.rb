class Cf < Formula
  desc "Filter to replace numeric timestamps with a formated date time"
  homepage "https://ee.lbl.gov/"
  url "https://ee.lbl.gov/downloads/cf/cf-1.2.5.tar.gz"
  sha256 "ef65e9eb57c56456dfd897fec12da8617c775e986c23c0b9cbfab173b34e5509"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1e71bfee55f962d8eaa0def16dbb90212f75adf1b3716994851805fcaab1f2a3" => :high_sierra
    sha256 "762c6903a856d2d686e763888016cee67c56aa887f965517c3903ec288d7e4e1" => :sierra
    sha256 "2767650e4a1a5f692f85ae481b4774c85e00bfd5e634142cc740276759ffe3ab" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    man1.mkpath
    system "make", "install"
    system "make", "install-man"
  end

  test do
    assert_match /Jan 20 00:35:44/, `echo 1074558944 | #{bin}/cf -u`
  end
end
