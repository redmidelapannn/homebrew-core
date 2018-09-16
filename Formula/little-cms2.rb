class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "http://www.littlecms.com/"
  # Ensure release is announced on http://www.littlecms.com/download.html
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.9/lcms2-2.9.tar.gz"
  sha256 "48c6fdf98396fa245ed86e622028caf49b96fa22f3e5734f853f806fbc8e7d20"
  version_scheme 1

  bottle do
    cellar :any
    rebuild 2
    sha256 "0e7c78e445a013ea460269f06bec608409001700ab563ad5bfb75c8890edc8e9" => :high_sierra
    sha256 "d03cea5acc16e3d2726af1b671bd50d3a9db5a011b3fb5630e3396886c7eb3e5" => :sierra
    sha256 "d3db3f4b6ba8b009205890880261dabd1d4a3c7cb3199684deeaf23b492ea972" => :el_capitan
  end

  depends_on "jpeg"
  depends_on "libtiff"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
