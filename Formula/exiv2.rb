class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "http://www.exiv2.org/"
  url "http://www.exiv2.org/builds/exiv2-0.27.0-Source.tar.gz"
  sha256 "ee88bc81539b73c65010651785d094fad0b39760a424b3c16c17e1856cfef2d7"
  head "https://github.com/Exiv2/exiv2.git"

  bottle do
    cellar :any
    sha256 "5cc550fce9c723b0ca4c0e9b07baff482a225ecfb7d649fa6509316b1d7fb827" => :mojave
    sha256 "1759941e17f488a35a4fdcdba24acc6a929f3771498704c7fb47797220657be3" => :high_sierra
    sha256 "60e924002febb9ceb94c9ab900013e61826e54650b85ec6fbbd4898bd5573aed" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "libssh"

  def install
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DEXIV2_ENABLE_XMP=ON
      -DEXIV2_ENABLE_VIDEO=ON
      -DEXIV2_ENABLE_PNG=ON
      -DEXIV2_ENABLE_NLS=ON
      -DEXIV2_ENABLE_PRINTUCS2=ON
      -DEXIV2_ENABLE_LENSDATA=ON
      -DEXIV2_ENABLE_VIDEO=ON
      -DEXIV2_ENABLE_WEBREADY=ON
      -DEXIV2_ENABLE_CURL=ON
      -DEXIV2_ENABLE_SSH=ON
      -DSSH_INCLUDE_DIR=#{Formula["libssh"].opt_include}
      -DSSH_LIBRARY=#{Formula["libssh"].opt_lib}/libssh.dylib
      -DEXIV2_BUILD_SAMPLES=OFF
      -DEXIV2_BUILD_PO=ON
      ..
    ]
    mkdir "build.cmake" do
      system "cmake", "-G", "Unix Makefiles", ".", *args
      system "make", "install"
    end
  end

  test do
    assert_match "288 Bytes", shell_output("#{bin}/exiv2 #{test_fixtures("test.jpg")}", 253)
  end
end
