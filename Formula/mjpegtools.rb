class Mjpegtools < Formula
  desc "Record and playback videos and perform simple edits"
  homepage "http://mjpeg.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.1.0/mjpegtools-2.1.0.tar.gz"
  sha256 "864f143d7686377f8ab94d91283c696ebd906bf256b2eacc7e9fb4dddcedc407"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "054efe127c8c3b1b14228e4fd59dbfce204c57c9ba02198738e78da60d921256" => :sierra
    sha256 "6cfc1bee0d34e91cb2a8f99f5b5ee2554dc6b3d9a176b39b76873df58b9f4767" => :el_capitan
    sha256 "b8cc49316ea846b1b450bf3a6e9370e77604afdee9175f9d2d180b86b7274c8f" => :yosemite
  end

  depends_on :x11 => :optional

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libquicktime" => :optional
  depends_on "libdv" => :optional
  depends_on "gtk+" => :optional
  depends_on "sdl_gfx" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-simd-accel",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
