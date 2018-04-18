class Caffe < Formula
  desc "Fast open framework for deep learning"
  homepage "https://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe/archive/1.0.tar.gz"
  sha256 "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f"

  bottle do
    rebuild 1
    sha256 "ecbea68740734cb95879d5912d5d6ba058cbffa000c57c29cc86cf60d62becfc" => :high_sierra
    sha256 "4839366c4fc17545f772c3e9eba2f4b1dc08f89adc4c5d2441ec94559abe5dac" => :sierra
    sha256 "f5c85ea0487c1f7a0ca62da0c1d8d5631ef8693db159702d3c4c847000bb376c" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gflags"
  depends_on "glog"
  depends_on "hdf5"
  depends_on "protobuf"
  depends_on "szip"
  depends_on "leveldb" => :optional
  depends_on "lmdb" => :optional
  depends_on "opencv" => :optional
  depends_on "snappy" if build.with?("leveldb")

  resource "test_model_weights" do
    url "http://dl.caffe.berkeleyvision.org/bvlc_reference_caffenet.caffemodel"
    sha256 "472d4a06035497b180636d8a82667129960371375bd10fcb6df5c6c7631f25e0"
  end

  def install
    args = std_cmake_args + %w[
      -DCPU_ONLY=ON
      -DUSE_NCCL=OFF
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_python=OFF
      -DBUILD_matlab=OFF
      -DBUILD_docs=OFF
      -DBUILD_python_layer=OFF
      -DALLOW_LMDB_NOLOCK=OFF
      -DUSE_OPENMP=OFF
    ]
    args << "-DUSE_OPENCV=" + (build.with?("opencv") ? "ON" : "OFF")
    args << "-DUSE_LMDB=" + (build.with?("lmdb") ? "ON" : "OFF")
    args << "-DUSE_LEVELDB=" + (build.with?("leveldb") ? "ON" : "OFF")

    system "cmake", ".", *args
    system "make", "install"
    pkgshare.install "models"
  end

  test do
    model = "bvlc_reference_caffenet"
    m_path = "#{pkgshare}/models/#{model}"
    resource("test_model_weights").stage do
      system "#{bin}/caffe", "test",
             "-model", "#{m_path}/deploy.prototxt",
             "-solver", "#{m_path}/solver.prototxt",
             "-weights", "#{model}.caffemodel"
    end
  end
end
