class Libparc < Formula
  desc "This library is part of hICN stack"
  homepage "https://github.com/FDio/cicn/blob/cframework/master/libparc/README.md"
  url "https://github.com/FDio/cicn", :using=>:git, :branch=>"cframework/master"
  version "1.0-65~g7944543~b3"

  bottle do
    sha256 "ee95df36e2f6629a3ae1e0722ce6c667e795d82788481f8c9a459588c21ba4da" => :mojave
    sha256 "0dd78a4b07a6c373994a22aefe45149bb12031fdb346b5ad85275c91659c4210" => :high_sierra
    sha256 "2741f7b08acc564359524e69eb9362c2c5fee2c16db9fbf555aaf359c6f5ac20" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "cmake", "libparc", *std_cmake_args
    system "make", "install", "-j"
  end

  test do
    system "true"
  end
end
