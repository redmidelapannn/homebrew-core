class Cgal < Formula
  desc "CGAL: Computational Geometry Algorithm Library"
  homepage "http://www.cgal.org/"
  url "https://github.com/CGAL/cgal/archive/releases/CGAL-4.8.tar.gz"
  sha256 "98f9eafbf7faffc48d0a5c3a1217d8d8e80bb0a753c76d1634236ea033722e36"

  bottle do
    cellar :any
    sha256 "b18af85311a901a4d4184d709c043c25795df31238bfafdbbdc149bc02d60b17" => :el_capitan
    sha256 "9063b58d5be90d86d954633febf2ecfc4b09a0b0dda0fd9cd6ae6830a7313e5e" => :yosemite
    sha256 "8406917b8f54cc6e2cb1be378e95147c3d242864355fcca0afe66a7e4aa9ec74" => :mavericks
  end

  option :cxx11

  deprecated_option "imaging" => "with-imaging"

  option "with-imaging", "Build ImageIO and QT compoments of CGAL"
  option "with-eigen3", "Build with Eigen3 support"
  option "with-lapack", "Build with LAPACK support"

  depends_on "cmake" => :build
  if build.cxx11?
    depends_on "boost" => "c++11"
    depends_on "gmp"   => "c++11"
  else
    depends_on "boost"
    depends_on "gmp"
  end
  depends_on "mpfr"

  depends_on "qt" if build.with? "imaging"
  depends_on "eigen" if build.with? "eigen3"

  # Allows to compile with clang 425: http://goo.gl/y9Dg2y
  #patch :DATA

  def install
    ENV.cxx11 if build.cxx11?
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
            "-DCMAKE_INSTALL_NAME_DIR=#{HOMEBREW_PREFIX}/lib",
           ]
    if build.without? "imaging"
      args << "-DWITH_CGAL_Qt3=OFF" << "-DWITH_CGAL_Qt4=OFF" << "-DWITH_CGAL_ImageIO=OFF"
    end
    if build.with? "eigen3"
      args << "-DWITH_Eigen3=ON"
    end
    if build.with? "lapack"
      args << "-DWITH_LAPACK=ON"
    end
    args << "."
    system "cmake", *args
    system "make", "install"
  end
end

# __END__
# diff --git a/src/CGAL/File_header_extended_OFF.cpp b/src/CGAL/File_header_extended_OFF.cpp
# index 3f709ff..f0e5bd3 100644
# --- a/src/CGAL/File_header_extended_OFF.cpp
# +++ b/src/CGAL/File_header_extended_OFF.cpp
# @@ -186,7 +186,8 @@ std::istream& operator>>( std::istream& in, File_header_extended_OFF& h) {
#         }
#         in >> keyword;
#     }
# -    in >> skip_until_EOL >> skip_comment_OFF;
# +    skip_until_EOL(in);
# +    skip_comment_OFF(in);
#     return in;
# }
# #undef CGAL_IN
