class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "http://www.littlecms.com/"
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.8/lcms2-2.8.tar.gz"
  sha256 "66d02b229d2ea9474e62c2b6cd6720fde946155cd1d0d2bffdab829790a0fb22"

  bottle do
    cellar :any
    revision 1
    sha256 "a891ae229e96dabbda2f0424dc3c0e77c19608d2fb89b3e5ef64fa208869cbbf" => :el_capitan
    sha256 "707f9d69c089cec7996deabf7c83875cc00e4d243e268fce89eb3a645b5f5287" => :yosemite
    sha256 "21616518b4735b289bb2f9913c4fcc2bd56a52c3185d14b0c66bef80053ebf40" => :mavericks
  end

  option :universal

  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended

  def install
    ENV.universal_binary if build.universal?

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
