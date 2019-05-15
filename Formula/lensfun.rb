class Lensfun < Formula
  desc "Remove defects from digital images"
  homepage "https://lensfun.github.io/"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.95/lensfun-0.3.95.tar.gz"
  sha256 "82c29c833c1604c48ca3ab8a35e86b7189b8effac1b1476095c0529afb702808"

  bottle do
    rebuild 1
    sha256 "fdfb6a8a9ce98032bbb287f3c12fc5485a2cd60f178a476a18be557c171406f8" => :mojave
    sha256 "2f3a49343c250655a9406ba19ff64e9a3a5b7d8b7ccfdaacc938623eae8736ee" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libpng"
  depends_on "python"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"lensfun-update-data"
  end
end
