class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/atari800/atari800/3.1.0/atari800-3.1.0.tar.gz"
  sha256 "901b02cce92ddb0b614f8034e6211f24cbfc2f8fb1c6581ba0097b1e68f91e0c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d5120925eb73c0bc972d4aeb8400fc2b05727219a60edc5f29f6cb3265622ca4" => :sierra
    sha256 "c7f31ff5d7cabc7a16771a5a77f8db8b07300a48608793dff3c5c0bf8978e2a8" => :el_capitan
    sha256 "889d502fa1d23a98037dc54607d7fa4a8d0527b72dd33b775470530e1daf28bc" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/atari800/source.git"
    depends_on "autoconf" => :build
  end

  depends_on "sdl"
  depends_on "libpng"

  def install
    chdir "src" do
      system "./autogen.sh" if build.head?
      system "./configure", "--prefix=#{prefix}",
                            "--disable-sdltest"
      system "make", "install"
    end
  end

  test do
    assert_equal "Atari 800 Emulator, Version #{version}",
                 shell_output("#{bin}/atari800 -v", 3).strip
  end
end
