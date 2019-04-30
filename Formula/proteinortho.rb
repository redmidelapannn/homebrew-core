class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0/proteinortho-v6.0.tar.gz"
  sha256 "b28f05c8c90a98bd65f2f1c1d9ed78e585959428c9f1a8deac1f53e72912de2c"
  depends_on "cmake" => :build  
  depends_on "pkg-config" => :build  
  depends_on "lapack" => :build  
  depends_on "gcc" => :build  

  def install
    system "mkdir", "#{prefix}/bin"
    ENV["LIBRARY_PATH"] = `pkg-config --libs --static lapack`.chomp
    ENV["CXX"] = `ls #{Formula["gcc"].opt_bin.realpath}/g++-* | sort | tail -n1`.chomp
    system "make", "CXX=#{ENV["CXX"]}", "CXXLIBRARY='#{ENV["LIBRARY_PATH"]}'" , "install", "PREFIX=#{prefix}/bin"
  end

  test do
    system "#{bin}/proteinortho", "-help"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
