class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.0/hfstospell-0.5.0.tar.gz"
  sha256 "0fd2ad367f8a694c60742deaee9fcf1225e4921dd75549ef0aceca671ddfe1cd"
  revision 3

  bottle do
    cellar :any
    sha256 "24ab8726e5ad0bef4e178c9f42396f3f7438c1daf711b5216cc14ec620dcb43d" => :mojave
    sha256 "7e96e4eb5f418ca97d1d9d16d089a3dff2bd84d1a9d281119b9b79dabeac8ccf" => :high_sierra
    sha256 "c911bd427cfc8aef940ca5dc0bcf85883b40fc222dff233a0b749ea07e93c779" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"
  depends_on "libxml++"

  # Fix "error: no template named 'auto_ptr' in namespace 'std'"
  # Upstream PR 20 Jun 2018 "C++14 (C++1y) should be the highest supported standard."
  # See https://github.com/hfst/hfst-ospell/pull/41
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
