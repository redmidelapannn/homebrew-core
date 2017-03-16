class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_0_13_0/openmsx-0.13.0.tar.gz"
  sha256 "41e37c938be6fc9f90659f8808418133601a85475058725d3e0dccf2902e62cb"
  head "https://github.com/openMSX/openMSX.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1e2d74abe57588cd739dc7313af84f4214fcc9368300ab649d5ab582b79954ec" => :sierra
    sha256 "1e2d74abe57588cd739dc7313af84f4214fcc9368300ab649d5ab582b79954ec" => :el_capitan
    sha256 "9dbbe6efea3623c28351192d5c2e6bd827df033e666def08cdb85edac8f4c313" => :yosemite
  end

  deprecated_option "without-opengl" => "without-glew"

  option "without-glew", "Disable OpenGL post-processing renderer"
  option "with-laserdisc", "Enable Laserdisc support"

  depends_on "sdl"
  depends_on "sdl_ttf"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "glew" => :recommended

  if build.with? "laserdisc"
    depends_on "libogg"
    depends_on "libvorbis"
    depends_on "theora"
  end

  def install
    # Fixes a clang crash; this is an LLVM/Apple bug, not an openmsx bug
    # https://github.com/Homebrew/homebrew-core/pull/9753
    # Filed with Apple: rdar://30475877
    ENV.O0

    inreplace "build/custom.mk", "/opt/openMSX", prefix
    # Help finding Tcl
    inreplace "build/libraries.py", /\((distroRoot), \)/, "(\\1, '/usr', '#{MacOS.sdk_path}/usr')"
    system "./configure"
    system "make"
    prefix.install Dir["derived/**/openMSX.app"]
    bin.write_exec_script "#{prefix}/openMSX.app/Contents/MacOS/openmsx"
  end

  test do
    system "#{bin}/openmsx", "-testconfig"
  end
end
