class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.0/hfstospell-0.5.0.tar.gz"
  sha256 "0fd2ad367f8a694c60742deaee9fcf1225e4921dd75549ef0aceca671ddfe1cd"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "9f57404244a9c075280b50d193a1d9cd78ab4c3af033fe91b931993fdb606cf4" => :high_sierra
    sha256 "a91c54dab9df897fee235229b7b8a382d6bcce2223aa604999429308cc52f364" => :sierra
    sha256 "40ae66776752fbc1475e33a798de7a9246f25dfb9e208db3a6ecdeee64b73fc6" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"
  depends_on "libxml++"

  # https://github.com/hfst/hfst-ospell/pull/41
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/674a62d/hfstospell/no-cxx17.diff"
    sha256 "0a3146e871ac0e3c71248b8671d09f6d8a8a69713b6f4857eab7bdb684709083"
  end

  needs :cxx11

  def install
    # icu4c 61.1 compatability
    ENV.append "CPPFLAGS", "-DU_USING_ICU_NAMESPACE=1"

    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hfst-ospell", "--version"
  end
end
