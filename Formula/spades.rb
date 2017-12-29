class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "http://cab.spbu.ru/files/release3.11.1/SPAdes-3.11.1.tar.gz"
  sha256 "3ab85d86bf7d595bd8adf11c971f5d258bbbd2574b7c1703b16d6639a725b474"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "3066680b167c5a97e38dd42662afecd213da5663de064873d5deced5314488ca" => :high_sierra
    sha256 "cb92820303923b993e85c4394c6eed305949f671568b8069e8b0e50f83005bde" => :sierra
    sha256 "1e9c3e6d04e4210033fd50ad27a4a2b349d1d463cd89ff841769ba0e267da189" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on :python if MacOS.version <= :snow_leopard

  needs :openmp

  def install
    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
