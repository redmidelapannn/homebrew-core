class Genkfs < Formula
  desc "Writes a KFS filesystem into a ROM file"
  homepage "https://github.com/KnightOS/genkfs"
  url "https://github.com/KnightOS/genkfs/archive/1.2.2.tar.gz"
  sha256 "93690989819ee93dd5130b2761879deaa3d70c706b050bd31eb8d5997cb683e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "8166d467a106b3d353f16a73d613181dca4ad2656916df46fde2fd863cbf8c09" => :catalina
    sha256 "da6b9f88833bd784599485b860816d635521fa032f38440ecb8864d471f8b22c" => :mojave
    sha256 "420348c6f4378657c04ae8f28abebbbb0e2b977ed73150c4757a8c452cd8089a" => :high_sierra
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build

  patch :DATA

  def install
    system "cmake", ".", *std_cmake_args, "-DCMAKE_INSTALL_MANDIR:PATH=#{man}"
    system "make", "install"
  end

  test do
    system bin/"genkfs", "--help"
    system "man", "genkfs"
    curl "https://github.com/KnightOS/kernel/releases/download/0.6.11/kernel-TI83p.rom", "-O"
    mkdir "model-directory"
    touch "model-directory/file.txt"
    system bin/"genkfs", "kernel-TI83p.rom", "model-directory"
    system "echo", "a32bc31e965e1d0f43a4ea064126576b67059e77219ccb359941a1b30b95f341", "kernel-TI83p.rom", "|", "sha256sum", "-c", "--"
  end
end
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 68c67e0..65c3277 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -28,7 +28,10 @@ ADD_CUSTOM_COMMAND(
   DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/genkfs.1
 )
 
+if (NOT DEFINED CMAKE_INSTALL_MANDIR)
+    set(CMAKE_INSTALL_MANDIR ${CMAKE_INSTALL_PREFIX}/man)
+endif()
 INSTALL(
     FILES ${CMAKE_CURRENT_BINARY_DIR}/genkfs.1
-    DESTINATION ${CMAKE_INSTALL_PREFIX}/man/man1
+    DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
 )
