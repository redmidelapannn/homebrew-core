class GlabelsQt < Formula
  desc "Label Designer gLabels v4 in QT"
  homepage "https://github.com/jimevins/glabels-qt/"
  url "https://github.com/jimevins/glabels-qt/archive/continuous.tar.gz"
  version "4.0"
  sha256 "4cbe87e26304aa0ac6454cab573b20c0e07f0acd5945065b96f2f5455b4845e9"
  bottle do
    cellar :any
    sha256 "c7b91f3e8b106e65733c7743a4a2c3950f9f060d5dc41a95bc52bfac6e8e3ebe" => :mojave
    sha256 "0346395fe94956bc55b0f502de16a9c0508badab08ea7a5b0eb2d3b2087b34a5" => :high_sierra
    sha256 "5a0bc2fa78a1289a78d7901d801de95bba485693673c9b5fb9b2bbc959f252a1" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "qt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/glabels-qt", "--version"
    system "#{bin}/glabels-batch-qt", "--version"
  end
end
