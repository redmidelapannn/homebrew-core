class Clzip < Formula
  desc "C language version of lzip"
  homepage "https://www.nongnu.org/lzip/clzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/clzip/clzip-1.11.tar.gz"
  sha256 "d9d51212afa80371dc2546d278ef8ebbb3cd57c06fdd761b7b204497586d24c0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e28ad2c4d63390f39c0825dac2dc92a6c03b7e2af6de3e195a1a9a0cd4bf22c1" => :mojave
    sha256 "c53efafdc162cc6f87c0eac5a804ef9212ffcfbd8abf13f635c6e7bed868b462" => :high_sierra
    sha256 "ddd99cd4586938a052601d0d2f69c81abd43d66ec1c205a7743cffd1774ce121" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "testsuite"
  end

  test do
    cp_r pkgshare/"testsuite", testpath
    cd "testsuite" do
      ln_s bin/"clzip", "clzip"
      system "./check.sh"
    end
  end
end
