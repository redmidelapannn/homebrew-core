class Libmf < Formula
  desc "open source tool for approximating an incomplete matrix."
  homepage "https://www.csie.ntu.edu.tw/~cjlin/libmf/"
  url "http://www.csie.ntu.edu.tw/~cjlin/libmf/libmf-2.01.zip"
  sha256 "75bb98a4e8f1a318d7d07556583727b4e301759904570bf527972d964d34ef30"
  bottle do
    cellar :any
    sha256 "477d6c2081ee27c82ef965a3092dfcb91acaa5e906cb9d8663d833074ab66ae0" => :el_capitan
    sha256 "b3e04172e94694de284753e57a83ffd44912ed06d1ba6733b56e18c4dc50d5ea" => :yosemite
    sha256 "ebc432b2fe4790411bc8b1993215741a7578f5ab4302b1ec9ebeb5afce782e8b" => :mavericks
  end

  patch :DATA

  def install
    system "make"
    system "make", "lib"
    cp "./mf-predict", bin
    cp "./mf-train", bin
    cp "./libmf.so.2", lib
  end

  test do
    system "mf-predict"
  end
end
__END__
diff --git a/Makefile b/Makefile
index fcdf25f..cf379d5 100644
--- a/Makefile
+++ b/Makefile
@@ -12,13 +12,13 @@ DFLAG = -DUSESSE
 #CXXFLAGS += -mavx
 
 # uncomment the following flags if you do not want to use OpenMP
-DFLAG += -DUSEOMP
-CXXFLAGS += -fopenmp
+# DFLAG += -DUSEOMP
+# CXXFLAGS += -fopenmp
 
 all: mf-train mf-predict
 
 lib: 
-	$(CXX) -shared -Wl,-soname,libmf.so.$(SHVER) -o libmf.so.$(SHVER) mf.o 
+	$(CXX) -shared -Wl,-install_name,libmf.so.$(SHVER) -o libmf.so.$(SHVER) mf.o 
 
 mf-train: mf-train.cpp mf.o
 	$(CXX) $(CXXFLAGS) $(DFLAG) -o $@ $^
