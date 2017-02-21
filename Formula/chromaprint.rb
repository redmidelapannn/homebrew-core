class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://bitbucket.org/acoustid/chromaprint/downloads/chromaprint-1.3.tar.gz"
  sha256 "3dc3ff97abdce63abc1f52d5f5f8e72c22f9a690dd6625271aa96d3a585b695a"
  revision 2

  bottle do
    cellar :any
    sha256 "6fb6910d427537717c1d7a752480a661a0f0bd1cdb2558fa162001108e21ffc2" => :sierra
    sha256 "cd7dc5421022bcbac77a16f5e5ad939c02fafc46104f03fd4a8155203f611c5e" => :el_capitan
    sha256 "b8562ae3151acda4b1b2249bb1e0c3fceeb32eafdf3f50856aa21ad37e4a912e" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
