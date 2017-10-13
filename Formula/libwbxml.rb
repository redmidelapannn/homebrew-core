class Libwbxml < Formula
  desc "Library and tools to parse and encode WBXML documents"
  homepage "https://sourceforge.net/projects/libwbxml/"
  url "https://downloads.sourceforge.net/project/libwbxml/libwbxml/0.11.6/libwbxml-0.11.6.tar.bz2"
  sha256 "2f5ffe6f59986b34f9032bfbf013e32cabf426e654c160d208a99dc1b6284d29"
  head "https://github.com/libwbxml/libwbxml.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "09cfe06bce72c07f979d3d728fed336201c3d01496b5f02bb340a52d4e24292d" => :high_sierra
    sha256 "aa05611d5cd4754461228a218d3c7d9fa5ac80d7ffc4540127cdf7d568a306ed" => :sierra
    sha256 "92655d131b4a2c6e9cb52f0e5119be288f6f965baecdc2b39f7446c3b9263aac" => :el_capitan
  end

  option "with-docs", "Build the documentation with Doxygen and Graphviz"
  option "with-verbose", "Build with verbose logging support"
  deprecated_option "docs" => "with-docs"

  depends_on "cmake" => :build
  depends_on "wget" => :optional

  if build.with? "docs"
    depends_on "doxygen" => :build
    depends_on "graphviz" => :build
  end

  def install
    # Sandbox fix:
    # Install in Cellar & then automatically symlink into top-level Module path.
    inreplace "cmake/CMakeLists.txt", "${CMAKE_ROOT}/Modules/", "#{share}/cmake/Modules"

    mkdir "build" do
      args = std_cmake_args
      args << "-DBUILD_DOCUMENTATION=ON" if build.with? "docs"
      args << "-DWBXML_LIB_VERBOSE=ON" if build.with? "verbose"
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
