class Jdep < Formula
  desc "Analyze Java .class files and produce Makefile dependencies."
  homepage "http://www.fudco.com/software/jdep.html"
  url "http://www.fudco.com/software/jdep-1.3.tar.gz"
  sha256 "3dd925ae2523cca59e4aaa7cbb8daa28927b40520f0f8dccead91d9edea1dc65"

  bottle do
    cellar :any_skip_relocation
    sha256 "627d3dc607ac30fb0a7add2dc12b4f5ab570f7301d6d45876fa3b7b1f862c3ec" => :el_capitan
    sha256 "024f8732bad7773edeba4fb007395abbd4219d3be9bb19bf096e439cea4e8940" => :yosemite
    sha256 "e428826cfdd16d21f170b12c03109a4b8a5c870ddac69dc4b1f6b375eaf25e27" => :mavericks
  end

  patch :DATA

  def install
    system "make"
    bin.install "bin/jdep"
    bin.install "bin/touchp"
    prefix.install "example"
  end

  test do
    cp_r "#{prefix}/example", "."
    system "make", "-C", "example"
  end
end
__END__
diff --git a/jdep.c b/jdep.c
index b415cb5..15573d6 100644
--- a/jdep.c
+++ b/jdep.c
@@ -25,7 +25,7 @@
 */
 
 #include <stdio.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include <string.h>
 #include <strings.h>
 #include <dirent.h>
diff --git a/jdep.c b/jdep.c
index 15573d6..8555936 100644
--- a/jdep.c
+++ b/jdep.c
@@ -67,8 +67,11 @@ PackageInfo *IncludedPackages = NULL;
 #define CONSTANT_Float                   4
 #define CONSTANT_Integer                 3
 #define CONSTANT_InterfaceMethodref     11
+#define CONSTANT_InvokeDynamic          18
 #define CONSTANT_Long                    5
 #define CONSTANT_Methodref              10
+#define CONSTANT_MethodHandle           15
+#define CONSTANT_MethodType             16
 #define CONSTANT_NameAndType            12
 #define CONSTANT_String                  8
 #define CONSTANT_Utf8                    1
@@ -670,6 +673,20 @@ readConstantPoolInfo(FILE *fyle, char *filename)
             char *str = (char *) readByteArray(fyle, length);
             return (cp_info *) build_constant_utf8_info(str);
         }
+        case CONSTANT_MethodHandle:{
+            readByte(fyle); /* reference_kind */
+            readWord(fyle); /* reference_index */
+            return NULL;
+        }
+        case CONSTANT_MethodType:{
+            readWord(fyle); /* descriptor_index */
+            return NULL;
+        }
+        case CONSTANT_InvokeDynamic:{
+            readWord(fyle); /* bootstrap_method_attr_index */
+            readWord(fyle); /* name_and_type_index */
+            return NULL;
+        }
         default:
             fprintf(stderr, "invalid constant pool tag %d in %s\n", tag,
                     filename);
diff --git a/jdep.c b/jdep.c
index 8555936..1397361 100644
--- a/jdep.c
+++ b/jdep.c
@@ -24,6 +24,7 @@
   Written by Chip Morningstar.
 */
 
+#include <unistd.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -153,6 +154,7 @@ analyzeClassFile(char *name)
 {
     FILE *outfyle;
     char outfilename[1000];
+    char depfilename[1000];
     char *deps[10000];
     int depCount;
     int i;
@@ -181,7 +183,10 @@ analyzeClassFile(char *name)
         fprintf(outfyle, "%s%s.class: \\\n", ClassRoot, name);
         for (i = 0; i < depCount; ++i) {
             if (index(deps[i], '$') == NULL) {
-                fprintf(outfyle, "  %s%s.java\\\n", JavaRoot, deps[i]);
+                snprintf(depfilename, sizeof(depfilename), "%s%s.java", JavaRoot, deps[i]);
+                if (access(depfilename, F_OK) != -1) {
+                    fprintf(outfyle, "  %s%s.java\\\n", JavaRoot, deps[i]);
+                }
             }
         }
         fprintf(outfyle, "\n");

