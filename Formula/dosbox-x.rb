class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "http://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.82.13.tar.gz"
  sha256 "e2721125b650ef995fc66f95766a995844f52aab0cf4261ff7aa998eb60e6f4c"
  version_scheme 1
  revision 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    sha256 "9c47f0c34f4fe71e6f040b8ec2144e155e3426fc1dfa24f644d3900a8c070f6d" => :mojave
    sha256 "dcf1982a16b6d8445f73281205a45fb2d1b67b0da3b2ac0ed980a6c2f0711fc9" => :high_sierra
    sha256 "d7eea6c18acce907edecc5f8d3e17a55b71f52d4df63d9782bf90b3d3c7a3992" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "ffmpeg"
  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "sdl"
  depends_on "sdl_net"
  depends_on "sdl_sound"

  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
      --enable-core-inline
    ]

    # Upstream fix for parallel build issue, remove in next version
    # https://github.com/joncampbell123/dosbox-x/commit/15aec75c
    inreplace "vs2015/sdl/build-dosbox.sh",
              "make -j || exit 1", "make || exit 1"

    system "./build-macosx", *args
    system "make", "install"
  end

  test do
    assert_match /DOSBox version #{version}/, shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
