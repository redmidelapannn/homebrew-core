class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0b/proteinortho-v6.0b.tar.gz"
  sha256 "f59c436f6461f318ccebc1177a67eb70c29ef9ba222ad724de1fb2a769a120b5"
  depends_on "cmake" => :build  
  depends_on "gcc"

  def install
    system "mkdir", "#{prefix}/bin"
    ENV["CXX"] = `ls #{Formula["gcc"].opt_bin.realpath}/g++-* | sort | tail -n1`.chomp
    system "make", "CPP=$CXX" , "install", "PREFIX=#{prefix}/bin"
  end

  test do
    system "#{bin}/proteinortho", "-help"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
