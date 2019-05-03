class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
#  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0/proteinortho-v6.0.tar.gz"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/master/proteinortho-master.tar.gz"
#  sha256 "1df4460f7cd5654c1e0c0c7abf546b50288265c895b1bf28dde618d7f080e805"
  sha256 "1eef1429adb5658b48575b0621863a4bfbafa4f858484427c413d3153f4ca61d"

  depends_on "cmake" => :build
  depends_on "gcc"
  #fails_with :clang # needs fortran

  def install
    bin.mkpath
    system "make", "CXX=g++", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-help"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
