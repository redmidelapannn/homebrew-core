class Itk < Formula
  desc "Insight Toolkit is a toolkit for performing registration and segmentation"
  homepage "https://www.itk.org/"
  url "https://downloads.sourceforge.net/project/itk/itk/5.0/InsightToolkit-5.0.0.tar.gz"
  sha256 "6ef73c8972e775632e4022a3a3158eacd039f095bb660d235b0affb9a9282b38"
  head "https://itk.org/ITK.git"

  bottle do
    sha256 "42f3dfca1054eab9060d54ced689693dfc1455b952d65c8478ceb830cb09cd5f" => :mojave
    sha256 "b2494ba3348c2e195ab25b2a5373017eb2c6331c307f64bdb2320d264ee79c60" => :high_sierra
    sha256 "d43b262b04136dd91e6be539ea5ed05bc0fb8d45555edd08489804c21196d8be" => :sierra
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
    system ENV.cxx, "-isystem", "#{include}/ITK-#{v}", "-o", "test.cxx.o", "-c", "test.cxx"
    # Linking step
    system ENV.cxx, "test.cxx.o", "-o", "test",
                    "#{lib}/libITKCommon-#{v}.1.dylib",
                    "#{lib}/libITKVNLInstantiation-#{v}.1.dylib",
                    "#{lib}/libitkvnl_algo-#{v}.1.dylib",
                    "#{lib}/libitkvnl-#{v}.1.dylib"
    system "./test"
  end
end
