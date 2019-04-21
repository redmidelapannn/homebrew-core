class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://downloads.sourceforge.net/project/gdcm/gdcm%202.x/GDCM%202.8.9/gdcm-2.8.9.tar.gz"
  sha256 "a2da88b7b3cbf9e76a9df3e89d06d057cca9ce54fc62fb059e04f47bf056b727"

  bottle do
    rebuild 1
    sha256 "b6bc82b9c39aef447898a1588f6518f82999d9f2fac83401eb6e7b8c10db5ac4" => :mojave
    sha256 "0ee5a41ec1271ff48c5d1280be0d14d9a88d5d8e067931468c9ea1f238c56de1" => :high_sierra
    sha256 "280ed2c1702762df9338e6babaebd6655e7093be0912c8724e682a8ecd2c5863" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "openjpeg"
  depends_on "openssl"
  depends_on "python"

  def install
    ENV.cxx11

    xy = Language::Python.major_minor_version "python3"
    python_include = Utils.popen_read("python3 -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'").chomp
    python_executable = Utils.popen_read("python3 -c 'import sys;print(sys.executable)'").chomp

    args = std_cmake_args + %W[
      -DGDCM_BUILD_APPLICATIONS=ON
      -DGDCM_BUILD_SHARED_LIBS=ON
      -DGDCM_BUILD_TESTING=OFF
      -DGDCM_BUILD_EXAMPLES=OFF
      -DGDCM_BUILD_DOCBOOK_MANPAGES=OFF
      -DGDCM_USE_VTK=OFF
      -DGDCM_USE_SYSTEM_OPENJPEG=ON
      -DGDCM_USE_SYSTEM_OPENSSL=ON
      -DGDCM_WRAP_PYTHON=ON
      -DPYTHON_EXECUTABLE=#{python_executable}
      -DPYTHON_INCLUDE_DIR=#{python_include}
      -DGDCM_INSTALL_PYTHONMODULE_DIR=#{lib}/python#{xy}/site-packages
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DGDCM_NO_PYTHON_LIBS_LINKING=ON
      -DPYTHON_VERSION_MAJOR=3
    ]

    mkdir "build" do
      ENV.append "LDFLAGS", "-undefined dynamic_lookup"

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cxx").write <<~EOS
      #include "gdcmReader.h"
      int main(int, char *[])
      {
        gdcm::Reader reader;
        reader.SetFileName("file.dcm");
      }
    EOS

    system ENV.cxx, "-isystem", "#{include}/gdcm-2.8", "-o", "test.cxx.o", "-c", "test.cxx"
    system ENV.cxx, "test.cxx.o", "-o", "test", "-L#{lib}", "-lgdcmDSED"
    system "./test"

    system "python3", "-c", "import gdcm"
  end
end
