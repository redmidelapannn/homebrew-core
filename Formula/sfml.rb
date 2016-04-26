class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "http://www.sfml-dev.org/"
  url "http://www.sfml-dev.org/files/SFML-2.3-sources.zip"
  sha256 "a1dc8b00958000628c5394bc8438ba1aa5971fbeeef91a2cf3fa3fff443de7c1"
  revision 1

  head "https://github.com/SFML/SFML.git"

  bottle do
    cellar :any
    revision 1
    sha256 "69cc86fba954b096724a9271c66982c6c961d4960b1128d99a87786c050f78c7" => :el_capitan
    sha256 "3b9c2131780eba7190e392c2b71d8943a12d65668244ecf74f466c8c5cf48058" => :yosemite
    sha256 "6d9cefbd38aa5421cf6aec80529e4df95a2e6dd6cc8847fdc4dd603707564ce7" => :mavericks
  end

  # Fix incorrect handling of RPATH for a system-wide installation of SFML libraries
  patch :DATA

  depends_on "cmake" => :build
  depends_on "doxygen" => :optional
  depends_on "flac"
  depends_on "freetype"
  depends_on "glew"
  depends_on "jpeg"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "openal-soft" => :optional

  # https://github.com/Homebrew/homebrew/issues/40301
  depends_on :macos => :lion

  def install
    args = std_cmake_args
    args << "-DSFML_BUILD_DOC=TRUE" if build.with? "doxygen"

    # Always remove the "extlibs" to avoid install_name_tool failure
    # (https://github.com/Homebrew/homebrew/pull/35279) but leave the
    # headers that were moved there in https://github.com/SFML/SFML/pull/795
    rm_rf Dir["extlibs/*"] - ["extlibs/headers"]

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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

__END__
diff --git a/cmake/Macros.cmake b/cmake/Macros.cmake
index 0cf8826..171d1e1 100644
--- a/cmake/Macros.cmake
+++ b/cmake/Macros.cmake
@@ -83,8 +83,8 @@ macro(sfml_add_library target)

         # adapt install directory to allow distributing dylibs/frameworks in user's frameworks/application bundle
         set_target_properties(${target} PROPERTIES
-                              BUILD_WITH_INSTALL_RPATH 1
-                              INSTALL_NAME_DIR "@rpath")
+                              BUILD_WITH_INSTALL_RPATH 0)
+        #                      INSTALL_NAME_DIR "@rpath")
     endif()

     # enable automatic reference counting on iOS
