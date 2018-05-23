class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://download.handbrake.fr/releases/1.1.0/HandBrake-1.1.0-source.tar.bz2"
  sha256 "a02e7c6f8bd8dc28eea4623663deb5971dcbca1ad59da9eb74aceb481d8c40da"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    rebuild 1
    sha256 "2f8f3cb9da0ba550fcca7817f2857ca8dc68a9f63b75ac1031da3ee5fd6261f8" => :high_sierra
    sha256 "c13e2cad7237e24709c1c4973507171097878b0823d9b2509027d0e12480f6a2" => :sierra
    sha256 "2843db48c25ca846bb6c72f116438061e6f728d46bbd5aa1976e5f54fe2f4ba9" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "yasm" => :build

  def install
    # -march=native causes segfaults
    ENV["HOMEBREW_OPTFLAGS"] = "-march=#{Hardware.oldest_cpu}" unless build.bottle?

    system "./configure", "--prefix=#{prefix}",
                          "--disable-xcode",
                          "--disable-gtk"
    system "make", "-C", "build"
    system "make", "-C", "build", "install"
  end

  test do
    system bin/"HandBrakeCLI", "--help"
  end
end
