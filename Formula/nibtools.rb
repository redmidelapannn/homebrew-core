class Nibtools < Formula
  desc "Commodore 1541/1571 disk image nibbler"
  homepage "https://c64preservation.com/dp.php?pg=nibtools"
  url "https://c64preservation.com/svn/nibtools/trunk", :using => :svn, :revision => "649"
  version "2014"
  sha256 "4e4bb0d2872084ae45d208ccf0868e1901fab99eb17e972e2f0351de63ac840a"

  bottle do
    cellar :any
    sha256 "21e93da68f3981f2775c2005a124bb7c5f6860722f0c675ebe5547a936c3bf26" => :mojave
    sha256 "bf621d61c718e1975c2a7406a6c9355b3bee26f443133aff67d100a05c6a42f3" => :high_sierra
    sha256 "b5b33d8c840fc87d9fc6ffb780026b47fdcacede406dd9205fbeffa32eb91c31" => :sierra
  end

  depends_on "cc65" => :build
  depends_on "opencbm" => :build
  depends_on "opencbm"

  def install
    system "make", "-f", "GNU/Makefile", "linux"
    mkdir bin.to_s
    cp %w[nibread nibwrite nibconv nibscan nibrepair nibsrqtest], bin.to_s
  end

  test do
    assert_path_exist("#{bin}/nibread")
    assert_path_exist("#{bin}/nibwrite")
    assert_path_exist("#{bin}/nibconv")
    assert_path_exist("#{bin}/nibscan")
    assert_path_exist("#{bin}/nibrepair")
    assert_path_exist("#{bin}/nibsrqtest")
  end
end
