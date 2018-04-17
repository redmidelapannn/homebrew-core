class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "http://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.1/logstalgia-1.1.1.tar.gz"
  sha256 "d693e432511d8de792ebe04cfb495fdcd38510641b4cd5f9b72f8a9a309a765b"

  bottle do
    rebuild 1
    sha256 "c8093d2e9fe700f09c77448cc4a587e45796840c2c5945f61270a3e2ed589bbd" => :high_sierra
    sha256 "5ff430b6b1e7a9d139cfde271976a55feaacdbe71c3d5bdda39b924da8a4986e" => :sierra
    sha256 "763774014004f0cbe63210a3a2453317508e814b0bb82b035906c0c44c4c5935" => :el_capitan
  end

  head do
    url "https://github.com/acaudwell/Logstalgia.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "glm" => :build
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre"

  needs :cxx11

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    # Handle building head.
    system "autoreconf", "-f", "-i" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Logstalgia v1.", shell_output("#{bin}/logstalgia --help")
  end
end
