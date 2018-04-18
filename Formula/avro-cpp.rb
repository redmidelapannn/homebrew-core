class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.8.2/cpp/avro-cpp-1.8.2.tar.gz"
  sha256 "5328b913882ee5339112fa0178756789f164c9c5162e1c83437a20ee162a3aab"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3a7b419a9631889a635cb5d11b10748825b2f1ced7a96a4895be7dc32e9e44cb" => :high_sierra
    sha256 "f1132e6c5228214cd07410f6e7d69ccb8a88eb5ec460e0c92592be6ce93bd574" => :sierra
    sha256 "5d72f75a8f99d5cc50c34a6c7c80788c605480cd53d561171c135479ee46e8af" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
