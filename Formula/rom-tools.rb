class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0196.tar.gz"
  version "0.196"
  sha256 "fc4436a23d7f2ef0b3c3f600c00745bc468541d0d29bcd3a1e0c599c5c02df7f"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d23e21552582f936a41e9ee78b6b82eebd822d29ae74a188fac31a44d832b26e" => :high_sierra
    sha256 "1382f4f54df36faf9d9f207d41c74d705f7a148b2d8fc6f9aa8802debc304b5a" => :sierra
    sha256 "ae98dbdf8d5aaf599240b30338ed1dfb0994e4bce0698fd152989869c0e99526" => :el_capitan
  end

  depends_on "python@2" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "flac"
  depends_on "portmidi"
  depends_on "utf8proc"

  def install
    inreplace "scripts/src/osd/sdl.lua", "--static", ""
    system "make", "TOOLS=1",
                   "PTR64=#{MacOS.prefer_64_bit? ? 1 : 0}", # for old Macs
                   "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1",
                   "USE_SYSTEM_LIB_UTF8PROC=1"
    bin.install %w[
      aueffectutil castool chdman floptool imgtool jedutil ldresample
      ldverify nltool nlwav pngcmp regrep romcmp src2html srcclean unidasm
    ]
    bin.install "split" => "rom-split"
    man1.install Dir["docs/man/*.1"]
  end

  # Needs more comprehensive tests
  test do
    # system "#{bin}/aueffectutil" # segmentation fault
    system "#{bin}/castool"
    assert_match "chdman info", shell_output("#{bin}/chdman help info", 1)
    system "#{bin}/floptool"
    system "#{bin}/imgtool", "listformats"
    system "#{bin}/jedutil", "-viewlist"
    assert_match "linear equation", shell_output("#{bin}/ldresample 2>&1", 1)
    assert_match "avifile.avi", shell_output("#{bin}/ldverify 2>&1", 1)
    system "#{bin}/nltool", "--help"
    system "#{bin}/nlwav", "--help"
    assert_match "image1", shell_output("#{bin}/pngcmp 2>&1", 10)
    assert_match "summary", shell_output("#{bin}/regrep 2>&1", 1)
    system "#{bin}/romcmp"
    system "#{bin}/rom-split"
    assert_match "template", shell_output("#{bin}/src2html 2>&1", 1)
    system "#{bin}/srcclean"
    assert_match "architecture", shell_output("#{bin}/unidasm", 1)
  end
end
