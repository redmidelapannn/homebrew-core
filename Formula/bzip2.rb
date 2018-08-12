class Bzip2 < Formula
  desc "Freely available high-quality data compressor"
  homepage "https://en.wikipedia.org/wiki/Bzip2"
  url "https://ftp.osuosl.org/pub/clfs/conglomeration/bzip2/bzip2-1.0.6.tar.gz"
  mirror "https://fossies.org/linux/misc/bzip2-1.0.6.tar.gz"
  sha256 "a2848f34fcd5d6cf47def00461fcb528a0484d8edef8208d6d2e2909dc61d9cd"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e4c516a86528e44d8aba92c6c48d4152861494cf23bbad0da1f9b270669b681d" => :high_sierra
    sha256 "f7d5babc6cc48b53058ac5d67f346158acc2ce7095bf797ce20f215d1420d32e" => :sierra
    sha256 "3e7b82686130e8990144c2f01e1cc38ad9103d39ba38186c1553be0573c2815e" => :el_capitan
  end

  keg_only :provided_by_macos

  def install
    inreplace "Makefile", "$(PREFIX)/man", "$(PREFIX)/share/man"

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    testfilepath = testpath + "sample_in.txt"
    zipfilepath = testpath + "sample_in.txt.bz2"

    testfilepath.write "TEST CONTENT"

    system "#{bin}/bzip2", testfilepath
    system "#{bin}/bunzip2", zipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end
