class Lensfun < Formula
  desc "Remove defects from digital images"
  homepage "http://lensfun.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.1/lensfun-0.3.1.tar.gz"
  sha256 "216c23754212e051c8b834437e46af3812533bd770c09714e8c06c9d91cdb535"
  revision 1
  head "http://git.code.sf.net/p/lensfun/code.git"

  bottle do
    revision 1
    sha256 "5067c72c5da082f6aa08d6d8e282f96847dc4fd307eeaf6c359963f50229c435" => :el_capitan
    sha256 "b7ab249171f582e19cbe25f72f66124907d16e8a65f532a697c80178f7696ef1" => :yosemite
    sha256 "b80bf1e67ef70c744d2d2c44712f25ed70fd9fd5ef15db678b75ef64496df68b" => :mavericks
  end

  depends_on :python3
  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "gettext"
  depends_on "libpng"
  depends_on "doxygen" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"lensfun-update-data"
  end
end
