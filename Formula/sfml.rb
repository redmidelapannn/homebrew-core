class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "https://www.sfml-dev.org/"
  url "https://www.sfml-dev.org/files/SFML-2.5.0-sources.zip"
  sha256 "26f133a1fcf7c99ce09005b5efd0aacaafd909b53091dc4dc3031c7984c771a4"
  head "https://github.com/SFML/SFML.git"

  bottle do
    cellar :any
    sha256 "8f52b1c633a7a2a193e5f02525bdf78c80f888d0743e2fb9fd4ac16bb2d41b2b" => :high_sierra
    sha256 "10e9b4757839a66c449a9af1a597d0618ab84246cf7632686e87bd84efe6840b" => :sierra
    sha256 "580cbc4ec09eb2ba9ed9e61947637ae0b3cce2e9b9a2b2943deb6477b57b3d9f" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :optional
  depends_on "flac"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "openal-soft" => :optional

  # https://github.com/Homebrew/homebrew/issues/40301
  depends_on :macos => :lion

  def install
    ENV["SDKROOT"] = MacOS.sdk_path

    args = std_cmake_args + %W[
      -DSFML_INSTALL_PKGCONFIG_FILES=TRUE
      -DSFML_MISC_INSTALL_PREFIX=#{pkgshare}
    ]
    args << "-DSFML_BUILD_DOC=TRUE" if build.with? "doxygen"

    # Always remove the "extlibs" to avoid install_name_tool failure
    # (https://github.com/Homebrew/homebrew/pull/35279) but leave the
    # headers that were moved there in https://github.com/SFML/SFML/pull/795
    rm_rf Dir["extlibs/*"] - ["extlibs/headers"]

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "Time.hpp"
      int main() {
        sf::Time t1 = sf::milliseconds(10);
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}/SFML/System", "-L#{lib}", "-lsfml-system",
           testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
