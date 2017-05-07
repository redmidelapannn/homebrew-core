class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/v18.tar.gz"
  sha256 "1cfd1b11ada04c0381b90b9561362d8e6b58cc0a0592925e2564b2bf36b5046c"
  head "https://github.com/dubhater/vapoursynth-mvtools.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2be870405583712f6640b75adfa046a1ccb221bd8eea6cc3d0629cab33b27dcf" => :sierra
    sha256 "c1d75cb7f1a3a3151ae683fc3752ebf572e2e8b88e54556238ad8ca5dd58e87b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "vapoursynth"
  depends_on "fftw"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :macos => :el_capitan # due to zimg

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
      MVTools will not be autoloaded in your VapourSynth scripts. To use it
      use the following code in your scripts:

        core.std.LoadPlugin(path="#{HOMEBREW_PREFIX}/lib/libmvtools.dylib")
    EOS
  end

  test do
    script = <<-PYTHON.undent.split("\n").join(";")
      import vapoursynth as vs
      core = vs.get_core()
      core.std.LoadPlugin(path="#{lib}/libmvtools.dylib")
    PYTHON

    system "python3", "-c", script
  end
end
