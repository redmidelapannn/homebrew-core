class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://download.handbrake.fr/releases/1.1.2/HandBrake-1.1.2-source.tar.bz2"
  sha256 "ba9a4a90a7657720f04e4ba0a2880ed055be3bd855e99c0c13af944c3904de2e"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    rebuild 1
    sha256 "4f89c9a5cef14f5b5fde7d0920d264e728e48168ee6209ec23a18ccc76a70785" => :mojave
    sha256 "89b7670fa1dbeb9ebc505cf1cd742ac4e3b056113e3f023baf07ed1c23a6624a" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "yasm" => :build

  def install
    # Upstream issue 8 Jun 2018 "libvpx fails to build"
    # See https://github.com/HandBrake/HandBrake/issues/1401
    if MacOS.version <= :el_capitan
      inreplace "contrib/libvpx/module.defs", /--disable-unit-tests/,
                                              "\\0 --disable-avx512"
    end

    if MacOS.version >= :mojave
      # Upstream issue 8 Sep 2018 "HandBrake 1.1.2: libvpx failed to be configured on macOS 10.14 Mojave"
      # See https://github.com/HandBrake/HandBrake/issues/1578
      inreplace "contrib/libvpx/module.defs", "--target=x86_64-darwin11-gcc", "--target=x86_64-darwin14-gcc"
    end

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
