class Itk < Formula
  desc "Insight Toolkit is a toolkit for performing registration and segmentation"
  homepage "https://www.itk.org/"
  url "https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.0.1/InsightToolkit-5.0.1.tar.gz"
  sha256 "613b125cbf58481e8d1e36bdeacf7e21aba4b129b4e524b112f70c4d4e6d15a6"
  head "https://itk.org/ITK.git"

  bottle do
    sha256 "043c8bb2431ca4ecb4f8e392afe98c2f6fce5688e80525356ad412fb0aa7af6e" => :mojave
    sha256 "c0f6268306bd86bf562d0cb28566483967e11bdfc18ca098394c0837de331fb7" => :high_sierra
    sha256 "24390090a8109b2c50ecf1c51ce3cc168c1b4722f281aa8976642a6ba9d3b367" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gdcm"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "vtk"

  def install
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTING=OFF
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DITK_USE_64BITS_IDS=ON
      -DITK_USE_STRICT_CONCEPT_CHECKING=ON
      -DITK_USE_SYSTEM_ZLIB=ON
      -DITK_USE_SYSTEM_EXPAT=ON
      -DModule_SCIFIO=ON
      -DITKV3_COMPATIBILITY:BOOL=OFF
      -DITK_USE_SYSTEM_FFTW=ON
      -DITK_USE_FFTWF=ON
      -DITK_USE_FFTWD=ON
      -DITK_USE_SYSTEM_HDF5=ON
      -DITK_USE_SYSTEM_JPEG=ON
      -DITK_USE_SYSTEM_PNG=ON
      -DITK_USE_SYSTEM_TIFF=ON
      -DITK_USE_SYSTEM_GDCM=ON
      -DITK_LEGACY_REMOVE=ON
      -DModule_ITKLevelSetsv4Visualization=ON
      -DModule_ITKReview=ON
      -DModule_ITKVtkGlue=ON
      -DITK_USE_GPU=ON
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cxx").write <<-EOS
      #include "itkImage.h"
      int main(int argc, char* argv[])
      {
        typedef itk::Image<unsigned short, 3> ImageType;
        ImageType::Pointer image = ImageType::New();
        image->Update();
        return EXIT_SUCCESS;
      }
    EOS

    v = version.to_s.split(".")[0..1].join(".")
    # Build step
    system ENV.cxx, "-std=c++11", "-isystem", "#{include}/ITK-#{v}", "-o", "test.cxx.o", "-c", "test.cxx"
    # Linking step
    system ENV.cxx, "-std=c++11", "test.cxx.o", "-o", "test",
                    "#{lib}/libITKCommon-#{v}.1.dylib",
                    "#{lib}/libITKVNLInstantiation-#{v}.1.dylib",
                    "#{lib}/libitkvnl_algo-#{v}.1.dylib",
                    "#{lib}/libitkvnl-#{v}.1.dylib"
    system "./test"
  end
end
