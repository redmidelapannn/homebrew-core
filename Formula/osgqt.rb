class Osgqt < Formula
  desc "Use OpenSceneGraph inside your Qt applications"
  homepage "https://github.com/openscenegraph/osgQt"
  url "https://github.com/openscenegraph/osgQt/archive/3.5.7.tar.gz"
  sha256 "dcc4436590639168e6470fe9c5343c82bca738d3296ebee014f40f2dc029afa1"

  bottle do
    cellar :any
    sha256 "45399eef4f5152104da3cbf3154e693e3d35b76d89991dfb4d62250cac135b5c" => :high_sierra
    sha256 "256c98e81bf9fa89e7d58153bf37d368e1d5b7c3edab1031178b38709caa7110" => :sierra
    sha256 "8a1b4853f0d6ec723cb6e5bbbf69507fd3e5dce423d1d557bf58fa1d59ed2f6c" => :el_capitan
  end

  option "with-docs", "Build the documentation with Doxygen"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "open-scene-graph"
  depends_on "qt"

  depends_on "doxygen" => :build if build.with? "docs"

  def install
    ENV.cxx11 if build.cxx11?

    args = std_cmake_args
    args << "-DBUILD_DOCUMENTATION=" + (build.with?("docs") ? "ON" : "OFF")

    if MacOS.prefer_64_bit?
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch_64_bit}"
    else
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch_32_bit}"
    end

    args << "-DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_prefix}"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
      doc.install Dir["#{prefix}/doc/OpenSceneGraphReferenceDocs/*"] if build.with? "docs"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <osg/Version>

      using namespace std;
      int main()
        {
          cout << osgGetVersion() << endl;
          return 0;
        }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{Formula["open-scene-graph"].opt_lib}/", "-losg", "-L#{lib}", "-losgqt", "-o", "test"
    system "./test"
  end
end
