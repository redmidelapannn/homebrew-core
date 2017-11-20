class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.13.tar.xz"
  sha256 "5115bd52bc20a707c1ecc7587e6389c17305348e2132a66cf767c62fc55ed45d"
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "28c1ccca0b4bbdda1ddfbc36eff78ac3891e7cc04b984e5c7947b3d09860fc09" => :high_sierra
    sha256 "26146415907ca0f23957a44c06a1b09f5ff3bdf5a9996160baa4c705944181e6" => :sierra
    sha256 "963ca5df16b4675e7b518f565f39a7baf22ad27947e61e9b8e32b715c71d5e8d" => :el_capitan
  end

  depends_on "doxygen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "--prefix=#{prefix}", ".", "output"
    system "ninja", "-C", "output"
    system "ninja", "-C", "output", "install"
  end
end
