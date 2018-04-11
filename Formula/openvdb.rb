class Openvdb < Formula
  desc "Sparse volume processing toolkit"
  homepage "http://www.openvdb.org/"
  url "https://github.com/dreamworksanimation/openvdb/archive/v5.1.0.tar.gz"
  sha256 "eb5a8011732bcdeb115de9a38f640ee376bcb85b54e060d3b1ab08f9dc92f40b"
  revision 1
  head "https://github.com/dreamworksanimation/openvdb.git"

  bottle do
    sha256 "c1d357bd0494914f492ed30514dc440e14e5fdc6a6d2030dd973175ce4543e0d" => :high_sierra
    sha256 "9ca647d716eb234b6bc8096ff23a0a84a4976fb86f9693bd2ad0fb522350436d" => :sierra
    sha256 "72993c2b9a3944706e21cf6a2b2faaa91367792e6eef6af2d38c79502e74fd4c" => :el_capitan
  end

  option "with-glfw", "Installs the command-line tool to view OpenVDB files"
  option "with-test", "Installs the unit tests for the OpenVDB library"
  option "with-logging", "Requires log4cplus"
  option "with-docs", "Installs documentation"

  deprecated_option "with-tests" => "with-test"
  deprecated_option "with-viewer" => "with-glfw"

  depends_on "boost"
  depends_on "ilmbase"
  depends_on "openexr"
  depends_on "tbb"
  depends_on "jemalloc" => :recommended

  depends_on "glfw" => :optional
  depends_on "cppunit" if build.with? "test"
  depends_on "doxygen" if build.with? "docs"
  depends_on "log4cplus" if build.with? "logging"
  needs :cxx11

  resource "test_file" do
    url "http://www.openvdb.org/download/models/cube.vdb.zip"
    sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
  end

  def install
    ENV.cxx11
    # Adjust hard coded paths in Makefile
    args = [
      "DESTDIR=#{prefix}",
      "BOOST_INCL_DIR=#{Formula["boost"].opt_include}",
      "BOOST_LIB_DIR=#{Formula["boost"].opt_lib}",
      "BOOST_THREAD_LIB=-lboost_thread-mt",
      "TBB_INCL_DIR=#{Formula["tbb"].opt_include}",
      "TBB_LIB_DIR=#{Formula["tbb"].opt_lib}",
      "EXR_INCL_DIR=#{Formula["openexr"].opt_include}/OpenEXR",
      "EXR_LIB_DIR=#{Formula["openexr"].opt_lib}",
      "BLOSC_INCL_DIR=", # Blosc is not yet supported.
      "PYTHON_VERSION=",
      "NUMPY_INCL_DIR=",
    ]

    if build.with? "jemalloc"
      args << "CONCURRENT_MALLOC_LIB_DIR=#{Formula["jemalloc"].opt_lib}"
    else
      args << "CONCURRENT_MALLOC_LIB="
    end

    if build.with? "glfw"
      args << "GLFW_INCL_DIR=#{Formula["glfw"].opt_include}"
      args << "GLFW_LIB_DIR=#{Formula["glfw"].opt_lib}"
      args << "GLFW_LIB=-lglfw"
    else
      args << "GLFW_INCL_DIR="
      args << "GLFW_LIB_DIR="
      args << "GLFW_LIB="
    end

    if build.with? "docs"
      args << "DOXYGEN=doxygen"
    else
      args << "DOXYGEN="
    end

    if build.with? "test"
      args << "CPPUNIT_INCL_DIR=#{Formula["cppunit"].opt_include}"
      args << "CPPUNIT_LIB_DIR=#{Formula["cppunit"].opt_lib}"
    else
      args << "CPPUNIT_INCL_DIR=" << "CPPUNIT_LIB_DIR="
    end

    if build.with? "logging"
      args << "LOG4CPLUS_INCL_DIR=#{Formula["log4cplus"].opt_include}"
      args << "LOG4CPLUS_LIB_DIR=#{Formula["log4cplus"].opt_lib}"
    else
      args << "LOG4CPLUS_INCL_DIR=" << "LOG4CPLUS_LIB_DIR="
    end

    ENV.append_to_cflags "-I #{buildpath}"

    cd "openvdb" do
      system "make", "install", *args
      if build.with? "test"
        system "make", "vdb_test", *args
        bin.install "vdb_test"
      end
    end
  end

  test do
    resource("test_file").stage testpath
    system "#{bin}/vdb_print", "-m", "cube.vdb"
  end
end
