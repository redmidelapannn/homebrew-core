class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20190823.2.tar.gz"
  sha256 "fb4630acdb1516cdeba8124a62bce9708488e3aa21c8e9a91fb60ee3599892a7"
  head "https://github.com/MaskRay/ccls.git"

  bottle do
    sha256 "b9dcafeca4dae438b3e30f4f82155f151c6cfa92907b7b6b7595b97d246200f8" => :mojave
    sha256 "2990cd4178dfce3373e640019f30ec558169169a4de5e0ce7191d389e8574397" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"
  depends_on :macos => :high_sierra # C++ 17 is required

  def install
    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"ccls", "-index=#{testpath}"
  end
end
