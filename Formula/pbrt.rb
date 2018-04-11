class Pbrt < Formula
  desc "Physically based rendering"
  homepage "http://pbrt.org/"
  url "https://github.com/mmp/pbrt-v2/archive/2.0.342.tar.gz"
  sha256 "397941435d4b217cd4a4adaca12ab6add9a960d46984972f259789d1462fb6d5"
  revision 1

  bottle do
    cellar :any
    sha256 "73158fad9aedb912e3ec36165588ab854da1ca78b463e4091e17d33153798d44" => :high_sierra
    sha256 "c28bde34450942ed0e47627e314363cf620e11cb61c9ee56cf385e2d2fcc5cb5" => :sierra
    sha256 "47f90958788384efc771191f4a0364f5eae47034cdb6ed1926b1f440eff424f7" => :el_capitan
  end

  depends_on "openexr"
  depends_on "flex"

  def install
    system "make", "-C", "src"
    prefix.install "src/bin"
  end

  test do
    system "#{bin}/pbrt", "--version"
  end
end
