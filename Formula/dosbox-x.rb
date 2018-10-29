class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "http://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/v0.801.tar.gz"
  sha256 "40f94cdcc5c9a374c522de7eb2c2288eaa8c6de85d0bd6a730f48bd5d84a89f9"
  revision 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "4f77b69bc62590c0bac275429faf330fb626ce4c22bcf67e5a78bc84294aeae6" => :mojave
    sha256 "1ccd587e817c1dd24c1367c12db36db0ffcdaa8e39c64b60e1624f531f2b7832" => :high_sierra
    sha256 "9bbbda736ff7aef5ac0ddaa293dac80e10659bcb4ea644ce3d61149a5afb5a73" => :sierra
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

    # Fix compilation issue: https://github.com/joncampbell123/dosbox-x/pull/308
    if DevelopmentTools.clang_build_version >= 900
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
