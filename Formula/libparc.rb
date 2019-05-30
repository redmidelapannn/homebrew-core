class Libparc < Formula
  desc "This library is part of hICN stack"
  homepage "https://github.com/FDio/cicn/blob/cframework/master/libparc/README.md"
  url "https://github.com/FDio/cicn", :using=>:git, :branch=>"cframework/master"
  version "1.0-65~g7944543~b3"

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
