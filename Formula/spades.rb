class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "http://cab.spbu.ru/files/release3.14.0/SPAdes-3.14.0.tar.gz"
  mirror "https://github.com/ablab/spades/releases/download/v3.14.0/SPAdes-3.14.0.tar.gz"
  sha256 "18988dd51762863a16009aebb6e873c1fbca92328b0e6a5af0773e2b1ad7ddb9"

  bottle do
    cellar :any
    sha256 "1a801678a91d7591d9b25dfe02c00e54d3b3a2b2878a9a85b50f962576ea6505" => :catalina
    sha256 "58d00ef06e8aa543b3ef580ccfd82c51eec570a4975ef669b6cadacd22cdc4d2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for OpenMP
  depends_on "python"

  fails_with :clang # no OpenMP support

  def install
    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spades.py --version 2>&1")
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
