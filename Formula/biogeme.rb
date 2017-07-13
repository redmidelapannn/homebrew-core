class Biogeme < Formula
  desc "Maximum likelihood estimation of choice models"
  homepage "https://biogeme.epfl.ch/"
  url "https://biogeme.epfl.ch/distrib/biogeme-2.6a.tar.gz"
  sha256 "f6de0ea12f83ed183f31a41b9a56d1ec7226d2305549fb89ea7b1de8273ede49"

  bottle do
    rebuild 1
    sha256 "afbe757699b17d085defe23cbecd4184b5d6f66cde4b2cf9e619c8eee00d21b0" => :sierra
    sha256 "a7ca064d6d2055950aebb9559847039ad9f9e00a5a48e7dc1361110995286ae8" => :el_capitan
    sha256 "64c44c42c4267e096d13e463f57bc06a509ec37874003f4e58b519273528e874" => :yosemite
  end

  depends_on :python3
  depends_on "gtkmm3"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"minimal.py").write <<-EOS.undent
      from biogeme import *
      rowIterator('obsIter')
      BIOGEME_OBJECT.SIMULATE = Enumerate({'Test':1},'obsIter')
    EOS
    (testpath/"minimal.dat").write <<-EOS.undent
      TEST
      1
    EOS
    system bin/"pythonbiogeme", "minimal", "minimal.dat"
  end
end
