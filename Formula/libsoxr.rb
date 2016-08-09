class Libsoxr < Formula
  desc "High quality, one-dimensional sample-rate conversion library"
  homepage "https://sourceforge.net/projects/soxr/"
  url "https://downloads.sourceforge.net/project/soxr/soxr-0.1.2-Source.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libs/libsoxr/libsoxr_0.1.2.orig.tar.xz"
  sha256 "54e6f434f1c491388cd92f0e3c47f1ade082cc24327bdc43762f7d1eefe0c275"

  bottle do
    cellar :any
    revision 1
    sha256 "a1a020e8e596fd933838b54a6f39631a9004b032f13cc1b3d92fa609185270c0" => :el_capitan
    sha256 "469d567bf0dc4b142f3894a6d2f65d90a9ee9c2103b0f4a27e7cb9ee3a7661a0" => :yosemite
    sha256 "1645d6f2d2ba2586d455b4e6377dfdbbd44ee567467564b096896fc04398dfc4" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
