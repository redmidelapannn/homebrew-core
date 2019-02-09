class Openvdb < Formula
  desc "Sparse volume processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v6.0.0.tar.gz"
  sha256 "dbdf3048336444c402e5d3727c9bfb2e84454b8d0fd468ba92a8c7225e24b7b4"
  head "https://github.com/AcademySoftwareFoundation/openvdb.git"

  bottle do
    rebuild 1
    sha256 "2e242e3701cc3adcb2cf1187cb68d83b7de4ea77530a8bae8a1653e4a36d9c24" => :mojave
    sha256 "9fcb44dae9c78ec39688538f8b1893cfb1ec1f335da2a066b4f4cf15f0ac8549" => :high_sierra
    sha256 "b95582d2851b9f1c4847f29af299fa657cbbb49c47777a6ee25569b00de7a5d4" => :sierra
  end

  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "c-blosc"
  depends_on "glfw"
  depends_on "ilmbase"
  depends_on "jemalloc"
  depends_on "openexr"
  depends_on "tbb"

  resource "test_file" do
    url "https://nexus.aswf.io/content/repositories/releases/io/aswf/openvdb/models/cube.vdb/1.0.0/cube.vdb-1.0.0.zip"
    sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
  end

  def install
    ENV.cxx11
    # Adjust hard coded paths in Makefile
    args = [
      "DESTDIR=#{prefix}",
      "BLOSC_INCL_DIR=#{Formula["c-blosc"].opt_include}",
      "BLOSC_LIB_DIR=#{Formula["c-blosc"].opt_lib}",
      "BOOST_INCL_DIR=#{Formula["boost"].opt_include}",
      "BOOST_LIB_DIR=#{Formula["boost"].opt_lib}",
      "BOOST_THREAD_LIB=-lboost_thread-mt",
      "CONCURRENT_MALLOC_LIB_DIR=#{Formula["jemalloc"].opt_lib}",
      "CPPUNIT_INCL_DIR=", # Do not use cppunit
      "CPPUNIT_LIB_DIR=",
      "DOXYGEN=doxygen",
      "EXR_INCL_DIR=#{Formula["openexr"].opt_include}/OpenEXR",
      "EXR_LIB_DIR=#{Formula["openexr"].opt_lib}",
      "LOG4CPLUS_INCL_DIR=", # Do not use log4cplus
      "LOG4CPLUS_LIB_DIR=",
      "NUMPY_INCL_DIR=",
      "PYTHON_VERSION=",
      "TBB_INCL_DIR=#{Formula["tbb"].opt_include}",
      "TBB_LIB_DIR=#{Formula["tbb"].opt_lib}",
      "GLFW_INCL_DIR=#{Formula["glfw"].opt_include}",
      "GLFW_LIB_DIR=#{Formula["glfw"].opt_lib}",
      "GLFW_LIB=-lglfw",
    ]

    ENV.append_to_cflags "-I #{buildpath}"

    cd "openvdb" do
      system "make", "install", *args
    end
  end

  test do
    resource("test_file").stage testpath
    system "#{bin}/vdb_print", "-m", "cube.vdb"
  end
end
