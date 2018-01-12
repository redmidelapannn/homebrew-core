class Caffe < Formula
  desc "Fast open framework for deep learning"
  homepage "http://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe/archive/1.0.tar.gz"
  sha256 "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f"

  bottle do
    sha256 "0df958579046961c87bb3fbcdf085b78b0f99e3446ec3be177b038c2c9ba0ce9" => :high_sierra
    sha256 "146b36786686c58a4ca29ad49d0d45324ffbf456f3820ebce1f1e6e5242cd723" => :sierra
    sha256 "3678b6e9c4d1b5f7362e56daaac60371018410400bb9c3ca6af325e8c7bb947f" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python"
  depends_on "gflags"
  depends_on "glog"
  depends_on "hdf5"
  depends_on "leveldb"
  depends_on "lmdb"
  depends_on "opencv"
  depends_on "protobuf"
  depends_on "python"
  depends_on "snappy"
  depends_on "szip"

  resource "test_model_weights" do
    url "http://dl.caffe.berkeleyvision.org/bvlc_reference_caffenet.caffemodel"
    sha256 "472d4a06035497b180636d8a82667129960371375bd10fcb6df5c6c7631f25e0"
  end

  def install
    args = std_cmake_args + %w[
      -DCPU_ONLY=ON
      -DUSE_NCCL=OFF
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_python=ON
      -DBUILD_matlab=OFF
      -DBUILD_docs=OFF
      -DBUILD_python_layer=ON
      -DUSE_OPENCV=ON
      -DUSE_LEVELDB=ON
      -DUSE_LMDB=ON
      -DALLOW_LMDB_NOLOCK=OFF
      -DUSE_OPENMP=OFF
    ]

    system "cmake", ".", *args
    system "make", "pycaffe", "install"
    share.install "models"
  end

  test do
    model = "bvlc_reference_caffenet"
    m_path = "#{share}/models/#{model}"
    resource("test_model_weights").stage { system "#{bin}/caffe", "test", "-model", "#{m_path}/deploy.prototxt", "-solver", "#{m_path}/solver.prototxt", "-weights", "#{model}.caffemodel" }
  end
end
