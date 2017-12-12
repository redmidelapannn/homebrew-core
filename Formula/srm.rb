class Srm < Formula
  desc "Secure replacement for rm(1)"
  homepage "https://srm.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/srm/1.2.15/srm-1.2.15.tar.gz"
  sha256 "7583c1120e911e292f22b4a1d949b32c23518038afd966d527dae87c61565283"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "02608c59d22e07eda8ad2cba27e192ba1a1be09e4ba49917b30acf51e8249a32" => :high_sierra
    sha256 "3c6f8ecd7375d1122a385de20e680f1961e311b56dc05ed3eb022672afc5ac79" => :sierra
    sha256 "12e0f7af7fd70111c462775b8de68c27483b0313cf0b253bf2039f3f7ca66159" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello_world.txt").write("Hello, world")
    system bin/"srm", testpath/"hello_world.txt"
  end
end
