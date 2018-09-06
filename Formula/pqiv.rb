class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.10.4.tar.gz"
  sha256 "58ddd18748e0b597aa126b7715f54f10b4ef54e7cd02cf64f7b83a23a6f5a14b"
  revision 1
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "389114528adf08cf36dcc576aac5bf01f60aef326e4941b497022a7dfccbc701" => :mojave
    sha256 "2f14aaadc0f670c57fc31463330fa502912e12ce589ec7e21a16c8d71173107d" => :high_sierra
    sha256 "6aed508b4e9236ba0977be0fe6064013af2337d7b51827a98acea981fdfd369e" => :sierra
    sha256 "459e1e1e1d5433cd469074023b2e2955b8cfaa6841089c4384485fa89e662852" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "libspectre"
  depends_on "poppler"
  depends_on "webp"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pqiv --version 2>&1")
  end
end
