class Libtommath < Formula
  desc "C library for number theoretic multiple-precision integers"
  homepage "https://www.libtom.net/LibTomMath/"
  url "https://github.com/libtom/libtommath/releases/download/v1.0.1/ltm-1.0.1.tar.xz"
  sha256 "47032fb39d698ce4cf9c9c462c198e6b08790ce8203ad1224086b9b978636c69"
  head "https://github.com/libtom/libtommath.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2aa5199eb41014f674f4d3e7d33f196f3369f31940bb3520dbd017304daad25f" => :high_sierra
    sha256 "4d46f1f2e94d3012f43eff83974015a0dea50135834b34519e08445c80d56cff" => :sierra
    sha256 "79a00d3b0e84595328cc2092a58e3eea9b189eed3cdaff99f7dc432cc220321a" => :el_capitan
  end

  def install
    ENV["DESTDIR"] = prefix

    system "make"
    system "make", "test_standalone"
    include.install Dir["tommath*.h"]
    lib.install "libtommath.a"
    pkgshare.install "test"
  end

  test do
    system pkgshare/"test"
  end
end
