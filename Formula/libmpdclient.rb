class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.16.tar.xz"
  sha256 "fa6bdab67c0e0490302b38f00c27b4959735c3ec8aef7a88327adb1407654464"
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1278424aa58fde35f3abf5434b630c99b5513c32a2b181fd8edd2f8f7649a700" => :mojave
    sha256 "b74e1f2a6f2dfc62d82ba23c1659c190afc8e29f2680d1fe94f90cb92446c45f" => :high_sierra
    sha256 "65b74bcbe88d3717fff094e6ff7a7f8fdfd9c3ed1475523b172c0bbf7627f65e" => :sierra
  end

  depends_on "doxygen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "--prefix=#{prefix}", ".", "output"
    system "ninja", "-C", "output"
    system "ninja", "-C", "output", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mpd/client.h>
      int main() {
        mpd_connection_new(NULL, 0, 30000);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lmpdclient", "-o", "test"
    system "./test"
  end
end
