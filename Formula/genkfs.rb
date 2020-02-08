class Genkfs < Formula
  desc "Writes a KFS filesystem into a ROM file"
  homepage "https://github.com/KnightOS/genkfs"
  url "https://github.com/KnightOS/genkfs/archive/1.2.2.tar.gz"

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
    system "wget", "https://github.com/KnightOS/kernel/releases/download/0.6.11/kernel-TI83p.rom"
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
