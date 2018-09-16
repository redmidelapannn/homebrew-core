class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_0_14_0/openmsx-0.14.0.tar.gz"
  sha256 "eb9ae4c8420c30b69e9a05edfa8c606762b7a6bf3e55d36bfb457c2400f6a7b9"
  head "https://github.com/openMSX/openMSX.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "3c91bab61713745345d8d63052cd6b3c9236384d0d80d5eafb98ab7965c77f89" => :mojave
    sha256 "e5ecfd16849bd730aaa41cfb0dc643454fb3e78c5bd68207cc43bcdddf8270ef" => :high_sierra
    sha256 "97b8ae1fdd3e2cea84e0c794aaa68c99e7b62cc9e6e76b955a80ee4070f0130e" => :sierra
    sha256 "03d6789aa2437ca7f2f9f6dd61a0ce65d54c4492d0b7a5021ebef1052dbd7028" => :el_capitan
  end

  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "sdl"
  depends_on "sdl_ttf"

  def install
    # Fixes a clang crash; this is an LLVM/Apple bug, not an openmsx bug
    # https://github.com/Homebrew/homebrew-core/pull/9753
    # Filed with Apple: rdar://30475877
    ENV.O0

    # Hardcode prefix
    inreplace "build/custom.mk", "/opt/openMSX", prefix

    # Help finding Tcl (https://github.com/openMSX/openMSX/issues/1082)
    inreplace "build/libraries.py" do |s|
      s.gsub! /\((distroRoot), \)/, "(\\1, '/usr', '#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework')"
      s.gsub! "lib/tcl", "."
    end

    system "./configure"
    system "make"
    prefix.install Dir["derived/**/openMSX.app"]
    bin.write_exec_script "#{prefix}/openMSX.app/Contents/MacOS/openmsx"
  end

  test do
    system "#{bin}/openmsx", "-testconfig"
  end
end
