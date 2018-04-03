class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  url "https://downloads.sourceforge.net/project/atari800/atari800/3.1.0/atari800-3.1.0.tar.gz"
  sha256 "901b02cce92ddb0b614f8034e6211f24cbfc2f8fb1c6581ba0097b1e68f91e0c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b81a496cd341c02dd0d28d3b0f8ac44976f238316b1d5a75117f117658fc2314" => :high_sierra
    sha256 "0d00590a06a38c4b62c91d29089af25dee6c670f3fef7157d982324f8a472c8c" => :sierra
    sha256 "ccc8350676e1c50aa05654188a46a557b625497556130a6f81ef1f6c974bc326" => :el_capitan
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
