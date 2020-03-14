class SvtHevc < Formula
  desc "Scalable Video Technology for HEVC Encoder"
  homepage "https://01.org/svt"
  url "https://github.com/OpenVisualCloud/SVT-HEVC/archive/v1.4.3.tar.gz"
  sha256 "08bf2b1075609788194bf983d693ab38ed30214ec966afa67895209fd0bf2179"
  head "https://github.com/OpenVisualCloud/SVT-HEVC.git"

  bottle do
    cellar :any
    sha256 "31a151f7caeea14aac9435b45e733a6ec8bfe5007dbe329e69497ee2ba64d3bc" => :catalina
    sha256 "5522b35c21383ea554c2e955b78a6bdf31e70547c3d37b4441f8b057149bf02d" => :mojave
    sha256 "52357f1c460c738950b5edbb421801a2f28380102352fddd0e752d2cda3346dd" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/SvtHevcEncApp --version")
  end
end
