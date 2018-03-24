class Submarine < Formula
  desc "Search and download subtitles"
  homepage "https://github.com/rastersoft/submarine"
  url "https://github.com/rastersoft/submarine/archive/0.1.7b.tar.gz"
  version "0.1.7b"
  sha256 "4569710a1aaf6709269068b6b1b2ef381416b81fa947c46583617343b1d3c799"
  revision 1
  head "https://github.com/rastersoft/submarine.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0da665b10594bb028765bff7adcabdb1c4a17294900cc3b3c4e26488db453738" => :high_sierra
    sha256 "b9c57f0f4a4c09c7cd8a2b0cf9748fd86e431eb6d4a8c54955776fe88c3bd8a4" => :sierra
    sha256 "346f954f7f995ae9f9ee07187248c537207b5934fe368de3c8a10e685ff6d4c1" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgee"
  depends_on "libsoup"
  depends_on "libarchive"

  def install
    # Parallelization build failure reported 2 Oct 2017 to rastersoft AT gmail
    ENV.deparallelize
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/submarine", "--help"
  end
end
