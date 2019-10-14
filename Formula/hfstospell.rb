class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.0/hfstospell-0.5.0.tar.gz"
  sha256 "0fd2ad367f8a694c60742deaee9fcf1225e4921dd75549ef0aceca671ddfe1cd"
  revision 7

  bottle do
    cellar :any
    sha256 "6997f84f6b27575de85fa5ccc120e649d5c96b4de48d509f8499aa829f6d0038" => :catalina
    sha256 "a579d1d2fbb038fafa91d5cdf725f80dcc9306b6c6f1e5f1bbd8e53dcd90978f" => :mojave
    sha256 "e3703ee1ff32ef028136bb803722bb350f22b37eef6c44e2d7c5972449820596" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"
  depends_on "libxml++"
  uses_from_macos "libxml2"

  # Fix "error: no template named 'auto_ptr' in namespace 'std'"
  # Upstream PR 20 Jun 2018 "C++14 (C++1y) should be the highest supported standard."
  # See https://github.com/hfst/hfst-ospell/pull/41
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/674a62d/hfstospell/no-cxx17.diff"
    sha256 "0a3146e871ac0e3c71248b8671d09f6d8a8a69713b6f4857eab7bdb684709083"
  end

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
