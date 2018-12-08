class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "http://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/v0.801.tar.gz"
  sha256 "40f94cdcc5c9a374c522de7eb2c2288eaa8c6de85d0bd6a730f48bd5d84a89f9"
  revision 1

  bottle do
    cellar :any
    rebuild 2
    sha256 "259a88062d75baf746615e9d366a86a72737103c25ba6742dcd6d8cdb2a8bec0" => :mojave
    sha256 "3d10d8bb8dd74ab0d334efbba543b2123df65723e14b24fc2294732d39425250" => :high_sierra
    sha256 "628f06f71fd7194f8d8cc842b39b4ab67f7bd91db6d3417dd7833a46ce993c3b" => :sierra
  end

  head do
    url "https://github.com/joncampbell123/dosbox-x.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "sdl"
  depends_on "sdl_net"
  depends_on "sdl_sound"

  conflicts_with "dosbox", :because => "both install `dosbox` binaries"

  # Otherwise build failure on Moutain Lion (#311)
  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
      --enable-core-inline
    ]

    if build.head?
      system "./build-macosx", *args
    else
      # Fix build failure due to missing <remote-ext.h> included from pcap.h
      # https://github.com/joncampbell123/dosbox-x/issues/275
      inreplace "src/hardware/ne2000.cpp", "#define HAVE_REMOTE\n", ""

      # Fix compilation issue: https://github.com/joncampbell123/dosbox-x/pull/308
      if DevelopmentTools.clang_build_version >= 900
        inreplace "src/hardware/serialport/nullmodem.cpp",
                  "setCD(clientsocket > 0)", "setCD(clientsocket != 0)"
      end

      system "./configure", *args
    end

    chmod 0755, "install-sh"
    system "make", "install"
  end

  test do
    assert_match /DOSBox version #{version}/, shell_output("#{bin}/dosbox -version 2>&1", 1)
  end
end
