class Libgsm < Formula
  desc "Lossy speech compression library"
  homepage "http://www.quut.com/gsm/"
  url "http://www.quut.com/gsm/gsm-1.0.16.tar.gz"
  sha256 "725a3768a1e23ab8648b4df9d470aed38eb1635af3cbc8d0b64fef077236f4ce"

  bottle do
    cellar :any
    sha256 "507ab917a624ad9e2d7d9da8244045a5b0d021595de2ad42c58a654db63101d5" => :sierra
    sha256 "3ee3d1675155cf22d8df381b6f461168148282e7bad0bc31c006ae270218f506" => :el_capitan
    sha256 "acacd8495ab4e8e29cc274318701b4c6ab043e3024979a2a66a7c317eb09df0a" => :yosemite
  end

  # Builds a dynamic library for gsm, this package is no longer developed
  # upstream. Patch taken from Debian and modified to build a dylib.
  patch do
    url "https://gist.githubusercontent.com/dholm/5840964/raw/1e2bea34876b3f7583888b2284b0e51d6f0e21f4/gistfile1.txt"
    sha256 "3b47c28991df93b5c23659011e9d99feecade8f2623762041a5dcc0f5686ffd9"
  end

  def install
    ENV.append_to_cflags "-c -O2 -DNeedFunctionPrototypes=1"

    # Only the targets for which a directory exists will be installed
    bin.mkpath
    lib.mkpath
    include.mkpath
    man1.mkpath
    man3.mkpath

    inreplace "Makefile", "libgsm.1.0.13.dylib", "libgsm.1.0.16.dylib"

    # Dynamic library must be built first
    system "make", "lib/libgsm.1.0.16.dylib",
           "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}",
           "LDFLAGS=#{ENV.ldflags}"
    system "make", "all",
           "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}",
           "LDFLAGS=#{ENV.ldflags}"
    system "make", "install",
           "INSTALL_ROOT=#{prefix}",
           "GSM_INSTALL_INC=#{include}"
    lib.install Dir["lib/*dylib"]
  end
end
