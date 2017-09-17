class Bzflag < Formula
  desc "3D multi-player tank battle game "
  homepage "https://bzflag.org"
  url "https://github.com/BZFlag-Dev/bzflag/archive/868a2be7cba3f2b706876f526cf8ba4c76e461d6.tar.gz"
  sha256 "17bd397a12b40f09f1d1a785266c9bc6b832153d18dfc87e44a5caaf40f94fc2"
  head "https://github.com/BZFlag-Dev/bzflag.git", :branch => "2.4"

  bottle do
    sha256 "fa4dd6a40f38b6e8f8dc4ed260a99b49eb81e442ff5ee06d28bd0586c44b3a56" => :sierra
    sha256 "ea37a41e741e2d27cd86c62ec7ffa60e9d4f9381d81929b7d64e21d7a7bfa71d" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "c-ares" => :build
  depends_on "libtool" => :build
  depends_on "sdl2"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make"
    system "make", "install"
  end

  test do
    system "file", "#{bin}/bzflag"
  end
end
