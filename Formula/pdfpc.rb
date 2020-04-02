class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.4.0.tar.gz"
  sha256 "5fc457b081cdf02708436bb708940fd6b689e03fc336d3faab652f0b85592c00"
  revision 1
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "ea034f377b9157631ff533d421b28e791a71698a8c0218ee08dca42f366c2f97" => :catalina
    sha256 "811b00b5213c6b9370f90631c32cd3f7296d1056725840ddb2e904c74c279819" => :mojave
    sha256 "9d8be759691eaa9ed57d2c125e213be5674d7dfcb6743c537c6b7c63398e38e9" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "vala" => :build
  depends_on "gst-plugins-good"
  depends_on "gtk+3"
  depends_on "libgee"
  depends_on "librsvg"
  depends_on "poppler"

  def install
    system "cmake", ".", "-DMOVIES=on", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/pdfpc", "--version"
  end
end
