class Libkate < Formula
  desc "Overlay codec for multiplexed audio/video in Ogg"
  homepage "https://code.google.com/archive/p/libkate/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libkate/libkate-0.4.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libk/libkate/libkate_0.4.1.orig.tar.gz"
  sha256 "c40e81d5866c3d4bf744e76ce0068d8f388f0e25f7e258ce0c8e76d7adc87b68"
  revision 1

  bottle do
    cellar :any
    rebuild 4
    sha256 "f4ed2d9195f154a3f6748e2bd4bf9258a279e8df7ed8565a6fb74f4139d67f53" => :mojave
    sha256 "0edf513b3e9966f7f5d4351537c21a026b0280625e335f3dd53bf471ef7d85af" => :high_sierra
    sha256 "e9b7b36d6182a89d16d9a794670986c083699c374c8b6259d22ec9fca60affbe" => :sierra
    sha256 "84072f9f5fbbe9eeea747729edbf5744dd389845ebb1115bca0725aca7de23c6" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libpng"

  fails_with :gcc do
    build 5666
    cause "Segfault during compilation"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"katedec", "-V"
  end
end
