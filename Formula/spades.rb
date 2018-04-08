class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "http://cab.spbu.ru/files/release3.11.1/SPAdes-3.11.1.tar.gz"
  sha256 "3ab85d86bf7d595bd8adf11c971f5d258bbbd2574b7c1703b16d6639a725b474"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "64b070cc2de46f97977955d7bd72b06faeede4e90c54636951959b7ecacd2025" => :high_sierra
    sha256 "e72dcd156232ed100ada6b1e2b2bfa7b03ca642b1e918f5b4235e2c23cecbf39" => :sierra
    sha256 "b9441f37b1e4845e98e70f436bc10f9b9f1ea72aaf984911d81608895db249e2" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "python@2"

  fails_with :clang # no OpenMP support

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
