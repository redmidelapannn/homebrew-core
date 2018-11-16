class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "http://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/v0.801.tar.gz"
  sha256 "40f94cdcc5c9a374c522de7eb2c2288eaa8c6de85d0bd6a730f48bd5d84a89f9"
  revision 1

  bottle do
    cellar :any
    rebuild 2
    sha256 "93431b65a30ee043d6523ff1fd7a7149ced221e261d7a3a5001dbc721b62648e" => :mojave
    sha256 "ada9fef892e359bcc02d55e42021b4231d7c4b3054c9eebd683eeac1a2081f82" => :high_sierra
    sha256 "e69576a7d66d3b9f145694bf39171e764513792a1402b060f70aa0fa9bc36617" => :sierra
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

    # Fix build failure due to missing <remote-ext.h> included from pcap.h
    # https://github.com/joncampbell123/dosbox-x/issues/275
    inreplace "src/hardware/ne2000.cpp", "#define HAVE_REMOTE\n", ""

    if build.head?
      system "./autogen.sh"
    # Fix compilation issue: https://github.com/joncampbell123/dosbox-x/pull/308
    elsif DevelopmentTools.clang_build_version >= 900
      inreplace "src/hardware/serialport/nullmodem.cpp",
                "setCD(clientsocket > 0)", "setCD(clientsocket != 0)"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-sdltest",
                          "--enable-core-inline"

    chmod 0755, "install-sh"
    system "make", "install"
  end

  test do
    assert_match /DOSBox version #{version}/, shell_output("#{bin}/dosbox -version 2>&1", 1)
  end
end
