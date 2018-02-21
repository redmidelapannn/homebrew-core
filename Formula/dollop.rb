class Dollop < Formula
  desc "Creates files with pseudo-random content (dollop)"
  homepage "https://robertomachorro.github.io/dollop/"
  url "https://github.com/RobertoMachorro/dollop/raw/archive/dollop-1.0.tar.gz"
  sha256 "07e799f8a59fc1014f762f7816d8013788a3762946dda635fa2504e6713ba5b7"
  bottle do
    cellar :any_skip_relocation
    sha256 "aa422f42da8dd0749020a0613ea9e77bccf77025f686e5e06173a3cd5d6c3ff9" => :high_sierra
    sha256 "0e01a3deee7f915906856f2d431b345529f7a1e024302d1a7ebc37a34cbad508" => :sierra
    sha256 "b5e49046180217378ab68cb641ee7bb352017ca6557facd90db2a95fce71ad21" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    system "#{bin}/dollop"
  end
end
