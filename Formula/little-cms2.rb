class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "http://www.littlecms.com/"
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.8/lcms2-2.8.tar.gz"
  sha256 "66d02b229d2ea9474e62c2b6cd6720fde946155cd1d0d2bffdab829790a0fb22"

  bottle do
    cellar :any
    rebuild 1
    sha256 "93ecc4a17e8fddef53c58f98318dde4248a787fa90e5d9c3e1a21e0c147c69b9" => :sierra
    sha256 "5192d5c0fc6b01eb421417e99d9c057519bcfa6436e8d587baaabc424a287c32" => :el_capitan
    sha256 "6a66611dd9a8fc5fb797102e86bc0f4c398e7720d3b73ad31a92b43206dcd883" => :yosemite
  end

  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--without-tiff" if build.without? "libtiff"
    args << "--without-jpeg" if build.without? "jpeg"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert File.exist?("out.jpg")
  end
end
