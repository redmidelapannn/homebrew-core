class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.4.2/chromaprint-1.4.2.tar.gz"
  sha256 "989609a7e841dd75b34ee793bd1d049ce99a8f0d444b3cea39d57c3e5d26b4d4"
  revision 1

  bottle do
    cellar :any
    sha256 "57beef30526b409d8d1c209dab6cf49d414f342506e46496fab4a2195362a461" => :sierra
    sha256 "bae97714d07387b9a54c8e097078391edc7cc3aeca7e0ea607d037d1608d6d26" => :el_capitan
    sha256 "5507edadeef7d703a9cf89edf2c5100d5bdbae8c67e428c7a39e07992853f820" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "fftw" => :optional

  def install
    args = std_cmake_args
    args << "-DFFT_LIB=fftw3" if build.with? "fftw"
    system "cmake", ".", *args
    system "make", "install"
  end
end
