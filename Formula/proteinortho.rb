class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0/proteinortho-v6.0.tar.gz"
  sha256 "400e5a6e147b43e9bb0e6bc977715516043b3e5035586b58b7b48748975c178c"
  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "pkg-config" => :build

  def install
    mkdir "#{bin}"
    ENV["LIBRARY_PATH"] = `pkg-config --libs --static lapack`.chomp
    ENV["CXX"] = `ls #{Formula["gcc"].opt_bin.realpath}/g++-* | sort | tail -n1`.chomp
    system "make", "CXX=#{ENV["CXX"]}", "CXXLIBRARY='#{ENV["LIBRARY_PATH"]}'", "install", "PREFIX=#{bin}"
  end

  test do
    system "#{bin}/proteinortho", "-help"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
