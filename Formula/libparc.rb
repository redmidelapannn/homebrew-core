class Libparc < Formula
  desc "This library is part of hICN stack"
  homepage "https://github.com/FDio/cicn/blob/cframework/master/libparc/README.md"
  url "https://github.com/FDio/cicn", :using=>:git, :branch=>"cframework/master"
  version "1.0-65~g7944543~b3"

  bottle do
    sha256 "8b019d9dae2e74239a4e216e5b9521b7a97a04152e3126c7ffd8ee9a3ab11063" => :mojave
    sha256 "bf8e4955be991e12e03573d2a7aa7c58546e5edee6647dc9e53bfb851929f0a7" => :high_sierra
    sha256 "11e2a4561882cc21f698bf82926bbe4b3337575f09a1e2c66bb2f17527ecacea" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "cmake", "libparc", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/parc-publickey", "-c", "keyfile.pkcs12", "12345", "test", "1024", "365"
  end
end
