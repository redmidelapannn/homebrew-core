class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.8.3.tar.gz"
  sha256 "f954f0ff2c356ca94c89b38f1dbc7951b2187b237cff513916445614aeb8d7f9"

  bottle do
    rebuild 1
    sha256 "a5b6a6e1396c4bf7c78379d0e2ab4f22ba74bd33408d5f6df6766d2e65bace95" => :high_sierra
    sha256 "96b4290ee4f29e6f454734a7627f213f6e3d7d70bbd8e1c745d4a3519521571a" => :sierra
    sha256 "dcdf8fceb867484527ac7cf58b8d8e6e6f079ca990f3b7957abaf385950d8743" => :el_capitan
  end

  option "with-openmp", "Enable OpenMP multithreading"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gcc" if build.with? "openmp"

  fails_with :clang if build.with? "openmp"

  def install
    args = []
    args << "--features=openmp" if build.with? "openmp"
    system "cargo", "install", "--root", prefix, *args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
