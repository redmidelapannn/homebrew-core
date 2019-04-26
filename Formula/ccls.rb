class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20190314.tar.gz"
  sha256 "aaefa603a76325bb94e5222d144e19c432771346990c8b84165832bf37d15bb3"
  revision 1
  head "https://github.com/MaskRay/ccls.git"

  bottle do
    sha256 "3ee91101172d5236ab08b7b4897afe410f082bc68fa40f9b81d0fa3059056624" => :mojave
    sha256 "9397a4cb384ace9b9aa788c420fa3211ba420c709ea9e5c0d3e968794d963cce" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"

  # C++17 is required
  fails_with :clang do
    build 900
  end
  fails_with :gcc => "4"
  fails_with :gcc => "5"
  fails_with :gcc => "6"
  fails_with :gcc => "7" do
    version "7.1"
  end

  def install
    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"ccls", "-index=#{testpath}"
  end
end
