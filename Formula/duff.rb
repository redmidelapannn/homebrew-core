class Duff < Formula
  desc "Quickly find duplicates in a set of files from the command-line"
  homepage "http://duff.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/duff/duff/0.5.2/duff-0.5.2.tar.gz"
  sha256 "15b721f7e0ea43eba3fd6afb41dbd1be63c678952bf3d80350130a0e710c542e"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "8a469e92a6303d80752ebc80ade382261d263b9c7226ca6652eddc8954e5ff2f" => :el_capitan
    sha256 "927ba61ce39cf9be33f796197063b1a6865bbc2db2f4b1340ad6786acf0494df" => :yosemite
    sha256 "0ad73b6368fb2689090493b7e3a06ce1f57878bc3d2deded66c1e024b6cf63dc" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    expected = <<-EOS.undent
      2 files in cluster 1 (6 bytes, digest 8843d7f92416211de9ebb963ff4ce28125932878)
      cmp1
      cmp2
    EOS

    (testpath/"cmp1").write "foobar"
    (testpath/"cmp2").write "foobar"

    assert_equal expected, shell_output("#{bin}/duff cmp1 cmp2")
  end
end
