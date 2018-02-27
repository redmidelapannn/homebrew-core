class OpenCobol < Formula
  desc "COBOL compiler"
  # Canonical domain: opencobol.org
  homepage "https://sourceforge.net/projects/open-cobol/"
  url "https://downloads.sourceforge.net/project/open-cobol/open-cobol/1.1/open-cobol-1.1.tar.gz"
  sha256 "6ae7c02eb8622c4ad55097990e9b1688a151254407943f246631d02655aec320"
  revision 1

  bottle do
    rebuild 1
    sha256 "357b27fe90c6aeeec8d8394254516c432f67df6b92a91888406af8454efbae80" => :high_sierra
    sha256 "2e482a8835f1af2ce50a4d6517df1e753df4c3431900791950b2677cb1f1c607" => :sierra
    sha256 "b7a1f1831c0f90248aaae28b5e78cfe85754a5c2881007f3f01bb9d946c7ed85" => :el_capitan
  end

  depends_on "gmp"
  depends_on "berkeley-db"

  conflicts_with "gnu-cobol",
    :because => "both install `cob-config`, `cobc` and `cobcrun` binaries"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make", "install"
  end

  test do
    system "#{bin}/cobc", "--help"
  end
end
