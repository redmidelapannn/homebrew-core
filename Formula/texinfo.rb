class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftpmirror.gnu.org/texinfo/texinfo-6.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/texinfo/texinfo-6.2.tar.xz"
  sha256 "ce6bbea247cf4f8f7bc47d4ac0f8841ec6792443350053b56ff0286053d94ced"

  bottle do
    sha256 "e60702473b77de8218fe94d6a8203fac5e13d4b9d66dbf5862319b7047abc2a9" => :el_capitan
    sha256 "0acb9ac867741ecf77d7ba41bf397c0d3611b5e76ff3db7be373153d73c5de7a" => :yosemite
    sha256 "71f59b22e56774558eb67da8dd6fa1e352c51be1cb3a58022259023b12fb5be0" => :mavericks
  end

  keg_only :provided_by_osx, <<-EOS.undent
    Software that uses TeX, such as lilypond and octave, require a newer version
    of these files.
  EOS

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-install-warnings",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["doc/refcard/txirefcard*"]
  end

  test do
    (testpath/"test.texinfo").write <<-EOS.undent
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS
    system "#{bin}/makeinfo", "test.texinfo"
    assert_match /Hello World!/, File.read("test.info")
  end
end
