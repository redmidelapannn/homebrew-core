class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0/proteinortho-v6.0.tar.gz"
  sha256 "e82522cdae62c182fc3bb75903e8ce3a388573fccbea16b72a0a8c47a653a34b"
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "lapack"
  depends_on "gcc" # for gfortran

  def install
    mkdir bin.to_s
    ENV["LIBRARY_PATH"] = `pkg-config --libs --static lapack`.chomp
    ENV["CXX"] = `ls #{Formula["gcc"].opt_bin.realpath}/g++-* | sort | tail -n1`.chomp
    system "make", "CXX=#{ENV["CXX"]}", "CXXLIBRARY='#{ENV["LIBRARY_PATH"]}'", "install", "PREFIX=#{bin}"
  end

  test do
    system "#{bin}/proteinortho", "-help"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
