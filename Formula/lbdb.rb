class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb_0.47.tar.gz"
  sha256 "cb8ccd75a9cba6fb099f6253c8b85542b800626d7270466236ec95830790ef1b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2215796bf8f7b48a8e2e80a1c0e5304abab894cf06be6c5e9ebfb7237395f833" => :mojave
    sha256 "bdd9d5ebefd810d9fe3f9ee672ed1b20c2f8fdac1a53d550f1753ed91d1784c7" => :high_sierra
    sha256 "2effc52fdf0177bcaa561824fc765040ff37f7d34f8761df43d84a2f94ca64e7" => :sierra
    sha256 "f1c26d036ad79a87ed52034ef52ed41e411dafbcce3e7a52b0404ca6542be5e1" => :el_capitan
  end

  depends_on "abook"

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}/lbdb"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
