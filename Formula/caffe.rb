class Caffe < Formula
  desc "Fast open framework for deep learning"
  homepage "http://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe/archive/1.0.tar.gz"
  sha256 "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f"

  head "https://github.com/BVLC/caffe.git"

  option "with-test", "Run tests during build step"

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

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "-j8"
      system "make", "runtest" if build.with?("test")
      system "make", "install"
    end
  end

  test do
    system "#{bin}/caffe", "--version"
    system "#{bin}/caffe", "device_query"
  end
end
