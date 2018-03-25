class Openclonk < Formula
  desc "Multiplayer action game"
  homepage "https://www.openclonk.org/"
  url "https://www.openclonk.org/builds/release/7.0/openclonk-7.0-src.tar.bz2"
  sha256 "bc1a231d72774a7aa8819e54e1f79be27a21b579fb057609398f2aa5700b0732"
  revision 2
  head "https://github.com/openclonk/openclonk", :using => :git

  bottle do
    cellar :any
    rebuild 1
    sha256 "15e7510e30abda07d5c51331ed4ad3c1c7c92b37186529ea78b02ca232c99267" => :high_sierra
    sha256 "44a8edc85434bd88d468f53efa5cc51f0a9c02c27ad0c541bd349d732784d38b" => :sierra
    sha256 "d73069a120fd612074b23387ec75803a7479a82d51461979121b79015519f7d4" => :el_capitan
  end

  # Requires some C++14 features missing in Mavericks
  depends_on :macos => :yosemite
  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "boost"
  depends_on "freealut"

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
    bin.write_exec_script "#{prefix}/openclonk.app/Contents/MacOS/openclonk"
    bin.install Dir[prefix/"c4*"]
  end

  test do
    system bin/"c4group"
  end
end
