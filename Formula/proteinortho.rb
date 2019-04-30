class Proteinortho < Formula
  desc "Proteinortho is a tool to detect orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0b/proteinortho-v6.0b.tar.gz"
  sha256 "f59c436f6461f318ccebc1177a67eb70c29ef9ba222ad724de1fb2a769a120b5"
  depends_on "cmake" => :build
  depends_on "gcc"

  # get the latest g++ compiler from brew (Cellar)
  CXX = `ls /usr/local/Cellar/gcc/*/bin/g++* | sort | tail -n1 | tr -d '\n'`

  def install
    system "make", "clean"
    system "make", "CPP=#{CXX}" , "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/proteinortho", "-help"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
