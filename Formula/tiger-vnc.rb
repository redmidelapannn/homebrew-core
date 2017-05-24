class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "http://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.8.0.tar.gz"
  sha256 "9951dab0e10f8de03996ec94bec0d938da9f36d48dca8c954e8bbc95c16338f8"

  bottle do
    rebuild 1
    sha256 "2cd45a5359b61efde4247bad3649d4b39722836c340bdc77ef5beeffbd76fe58" => :sierra
    sha256 "a69639d0a96e0944c3a58ef657e28a0aa61cb925c15364ae7b7e74e0e009fba6" => :el_capitan
    sha256 "b83231dc77d2d27562cd6378cec44a1bfb3b34c2575a4fb36b05899edd7f017c" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "gnutls" => :recommended
  depends_on "jpeg-turbo"
  depends_on "gettext"
  depends_on "fltk"
  depends_on :x11

  # Remove for > 1.8.0
  # Fix "redefinition of 'kVK_RightCommand' as different kind of symbol"
  # Upstream commit from 24 May 2017 "Compatibility with macOS 10.12 SDK"
  patch do
    url "https://github.com/TigerVNC/tigervnc/commit/2b0a0ef0.patch"
    sha256 "a0129712ecbd154b0ba1ac2714373514c72df92fd4ee1fd8aed2da231435949f"
  end

  def install
    turbo = Formula["jpeg-turbo"]
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{turbo.include}
      -DJPEG_LIBRARY=#{turbo.lib}/libjpeg.dylib
      .
    ]
    system "cmake", *args
    system "make", "install"
  end
end
