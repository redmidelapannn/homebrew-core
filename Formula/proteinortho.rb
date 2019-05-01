class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0/proteinortho-v6.0.tar.gz"
  sha256 "5fbfe0e7cb28f5f614a97fc2286d5df55f4c355ebbf3590a61005c56b915b53a"

  depends_on "cmake" => :build
  fails_with :clang # needs fortran

  def install
    mkdir bin.to_s
    system "make", "install", "PREFIX=#{bin}"
  end

  test do
    system "#{bin}/proteinortho", "-help"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
