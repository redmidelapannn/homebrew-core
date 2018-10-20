class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  head "https://github.com/rdiankov/collada-dom.git"

  stable do
    url "https://downloads.sourceforge.net/project/collada-dom/Collada%20DOM/Collada%20DOM%202.4/collada-dom-2.4.0.tgz"
    sha256 "5ca2d12f744bdceff0066ed3067b3b23d6859581fb0d657f98ba4487d8fa3896"

    # Fix build of minizip: quoting arguments to cmake's add_definitions doesn't work the way they thought it did.
    # Fixed in 2.4.2; remove this when version gets bumped
    # https://github.com/rdiankov/collada-dom/issues/3
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 "52aaee0061ff82e59f202165ccfa27341e9c4b961df17ba47b5a0058627c53c6" => :mojave
    sha256 "fefdc39ab954c6bf471612e21b6898c700e6b0cb21c6fe2476a20cfd424d4585" => :high_sierra
    sha256 "30a18efcd4cd5a8b90c2404f4d820a9c902d614f1b49c62310c757c58c196eaa" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "pcre"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 72b6deb..0c7f7ce 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -100,7 +100,7 @@ endif()

 if( APPLE OR ${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
   # apple doesn't have 64bit versions of file opening functions, so add them
-  add_definitions("-Dfopen64=fopen -Dfseeko64=fseeko -Dfseek64=fseek -Dftell64=ftell -Dftello64=ftello")
+  add_definitions(-Dfopen64=fopen -Dfseeko64=fseeko -Dfseek64=fseek -Dftell64=ftell -Dftello64=ftello)
 endif()

 set(COLLADA_DOM_INCLUDE_INSTALL_DIR "include/collada-dom")
