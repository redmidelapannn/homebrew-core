class BayesianAnalysisToolkit < Formula
  desc "Bayesian analysis toolkit"
  homepage "https://bat.mpp.mpg.de/"
  url "https://github.com/bat/bat/releases/download/v1.0.0/BAT-1.0.0.tar.gz"
  sha256 "620e8069d85f18f8504137823621cbb578fa5b159e3074f0f2379ac295dd1482"

  bottle do
    sha256 "f27f97861e059c00df6786edf3326bf389ea1f45bdd3f0d4cffb7ddba5f40f34" => :high_sierra
    sha256 "4b71af7c2b2359f4b78859c854ca52386f66b9a28e06772f40c0bc7237056e22" => :sierra
    sha256 "7dd567ffd83242fc26673c0f94868f7e8d9550d5a4c512ee29e5203d02aabdf2" => :el_capitan
  end

  depends_on "cuba"
  depends_on "root"

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}/bat", "--with-cuba"
    system "make", "install"
    (pkgshare/"examples").install "examples/basic"
    (pkgshare/"examples").install "examples/advanced"
  end

  test do
    system "#{pkgshare}/examples/basic/binomial/runEfficiency"
  end
end
