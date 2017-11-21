class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "http://www.exiv2.org/"
  url "http://www.exiv2.org/builds/exiv2-0.26-trunk.tar.gz"
  sha256 "c75e3c4a0811bf700d92c82319373b7a825a2331c12b8b37d41eb58e4f18eafb"

  bottle do
    cellar :any
    rebuild 2
    sha256 "299a66844e436d62367acec6954691cee595afe6d285d75237b70036d562b856" => :high_sierra
    sha256 "d7d01ec73aafae54f0a5dba74001970861cdbdd4c78f0e26e7c67d7f47657fe8" => :sierra
    sha256 "312e08cccdecb7801e489008ad7374b2d1e0aa7aded6450b83ceda3beed3e567" => :el_capitan
  end

  head do
    url "https://github.com/Exiv2/exiv2.git"
    depends_on "cmake" => :build
    depends_on "gettext" => :build
    depends_on "libssh"
  end

  def install
    if build.head?
      args = std_cmake_args
      args += %W[
        -DEXIV2_ENABLE_SHARED=ON
        -DEXIV2_ENABLE_XMP=ON
        -DEXIV2_ENABLE_LIBXMP=ON
        -DEXIV2_ENABLE_VIDEO=ON
        -DEXIV2_ENABLE_PNG=ON
        -DEXIV2_ENABLE_NLS=ON
        -DEXIV2_ENABLE_PRINTUCS2=ON
        -DEXIV2_ENABLE_LENSDATA=ON
        -DEXIV2_ENABLE_COMMERCIAL=OFF
        -DEXIV2_ENABLE_BUILD_SAMPLES=ON
        -DEXIV2_ENABLE_BUILD_PO=ON
        -DEXIV2_ENABLE_VIDEO=ON
        -DEXIV2_ENABLE_WEBREADY=ON
        -DEXIV2_ENABLE_CURL=ON
        -DEXIV2_ENABLE_SSH=ON
        -DSSH_LIBRARY=#{Formula["libssh"].opt_lib}/libssh.dylib
        -DSSH_INCLUDE_DIR=#{Formula["libssh"].opt_include}
        ..
      ]
      mkdir "build.cmake" do
        system "cmake", "-G", "Unix Makefiles", ".", *args
        system "make", "install"
        # `-DCMAKE_INSTALL_MANDIR=#{man}` doesn't work
        mv prefix/"man", man
      end
    else
      system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
      system "make", "install"
    end
  end

  test do
    assert_match "288 Bytes", shell_output("#{bin}/exiv2 #{test_fixtures("test.jpg")}", 253)
  end
end
