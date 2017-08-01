class Png2ico < Formula
  desc "PNG to icon converter"
  homepage "https://www.winterdrache.de/freeware/png2ico/"
  url "https://www.winterdrache.de/freeware/png2ico/data/png2ico-src-2002-12-08.tar.gz"
  sha256 "d6bc2b8f9dacfb8010e5f5654aaba56476df18d88e344ea1a32523bb5843b68e"
  revision 1

  bottle do
    cellar :any
    rebuild 3
    sha256 "51d8e5fc343db343d6ea0aa4e8a88834e638a069db2873087d5ad899ccfc373f" => :sierra
    sha256 "b6637ff9c23d9e90f15a941a49e4e50bcc040c5207c66d31c9d5822d4b4ef0ca" => :el_capitan
    sha256 "85e79ceb24b93222a6af953ebfb747e4d41a79281644e8ecf13d3d5598d0d96d" => :yosemite
  end

  depends_on "libpng"

  # Fix build with recent clang
  patch :DATA

  def install
    inreplace "Makefile", "g++", "$(CXX)"
    system "make", "CPPFLAGS=#{ENV.cxxflags} #{ENV.cppflags} #{ENV.ldflags}"
    bin.install "png2ico"
    man1.install "doc/png2ico.1"
  end

  test do
    system "#{bin}/png2ico", "out.ico", test_fixtures("test.png")
    assert File.exist?("out.ico")
  end
end

__END__
diff --git a/png2ico.cpp b/png2ico.cpp
index 8fb87e4..9dedb97 100644
--- a/png2ico.cpp
+++ b/png2ico.cpp
@@ -34,6 +34,7 @@ Notes about transparent and inverted pixels:
 #include <cstdio>
 #include <vector>
 #include <climits>
+#include <cstdlib>
 
 #if __GNUC__ > 2
 #include <ext/hash_map>
