class Ufoai < Formula
  desc "UFO: Alien Invasion"
  homepage "https://ufoai.org/"
  url "https://git.code.sf.net/p/ufoai/code.git", :branch => "ufoai_2.5", :revision => "3e28f7cbf9f5e1cfd0fa7fdc852f833e498757c1"
  version "2.5.0+20150216"
  revision 1

  bottle do
    rebuild 1
    sha256 "a80203ffc121490fc06d6adfe4cde09d619dcf7041ae62955742c323cf973ba8" => :sierra
    sha256 "0838d22a0aa3a4aa3af0b7f4f6de4d66c5fd5495ba796aade62adef257592446" => :el_capitan
    sha256 "17bbdc6f76ed7293b73458cd236f39ce596c4388097cb276605308be7ef3700d" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "sdl2_ttf"
  depends_on "sdl2_mixer"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "xvid"
  depends_on "theora"
  depends_on "gettext"

  resource "data" do
    url "https://downloads.sourceforge.net/project/ufoai/UFO_AI%202.x/2.5/ufoai-2.5-data.tar"
    sha256 "5e706a424aff6a2ea30a4c798129d6304e897387eadf808528129b512b7dcdb0"
  end

  def install
    ENV.deparallelize
    ENV["TARGET_ARCH"] = MacOS.preferred_arch.to_s

    (buildpath/"base").install resource("data")

    inreplace "build/install_mac.mk" do |s|
      s.gsub! /.*\$\(BINARIES_BASE\).*/, ""
      s.gsub! /\s+copylibs-ufoai/, ""
      s.gsub! /.*hdiutil.*/, ""
    end
    inreplace "build/modes/release.mk", /-falign-(loops|jumps)=\d+/, "" unless ENV.compiler == :gcc

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-hardlinkedgame
      --enable-release
    ]
    system "./configure", *args
    system "make"
    system "make", "lang"
    system "make", "create-dmg-ufoai"
    prefix.install Dir["contrib/installer/mac/ufoai-**/UFOAI.app"]
    bin.write_exec_script "#{prefix}/UFOAI.app/Contents/MacOS/ufo"
  end

  def caveats; <<-EOS.undent
    Turn off GLSL shaders from video settings if you have graphics problem.
    EOS
  end

  test do
    system "#{bin}/ufo", "+set", "vid_fullscreen", "0", "+quit"
  end
end
