class Viennacl < Formula
  desc "Linear algebra library for many-core architectures and multi-core CPUs"
  homepage "http://viennacl.sourceforge.net"
  url "https://downloads.sourceforge.net/project/viennacl/1.7.x/ViennaCL-1.7.0.tar.gz"
  sha256 "0dd062770f8cf92309b2473d5defc7a6b4c874170e350e6a7ad0f4c791c49eff"
  head "https://github.com/viennacl/viennacl-dev.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "f7a6b5c9f1c1d25c52341e1a8cc03c58e986d952c67691581af8083bdcb5d53e" => :el_capitan
    sha256 "52353934ef5ccaa467924a4f31a6eb553c69fa21b9cf9b520c892e2c66a67336" => :yosemite
    sha256 "eb32ce84ba17a167cdcfce866e1352b5351fffc0ccebd951e5785976cb1c3536" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on :macos => :snow_leopard

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    libexec.install "#{buildpath}/examples/benchmarks/dense_blas-bench-cpu" => "test"
  end

  test do
    system "#{opt_libexec}/test"
  end
end
