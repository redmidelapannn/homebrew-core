class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://libsdl.org/release/SDL2-2.0.5.tar.gz"
  sha256 "442038cf55965969f2ff06d976031813de643af9c9edc9e331bd761c242e8785"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c43988c1ea7af5179f6ba55b668f74374e7d14c5940321c43a52e53ba0ed2bc4" => :sierra
    sha256 "d54cd02a8269caec76bd8204da59e79f82a0fc7e06ad208ed2743a32995c680b" => :el_capitan
    sha256 "0450297653f20ad17c2af0c000132f94f977c3049fee9383af2c9e4e51793e50" => :yosemite
  end

  head do
    url "https://hg.libsdl.org/SDL", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "Compile and install the tests"
  option :universal

  # https://github.com/mistydemeo/tigerbrew/issues/361
  if MacOS.version <= :snow_leopard
    patch do
      url "https://gist.githubusercontent.com/miniupnp/26d6e967570e5729a757/raw/1a86f3cdfadbd9b74172716abd26114d9cb115d5/SDL2-2.0.3_OSX_104.patch"
      sha256 "4d01f05f02568e565978308e42e98b4da2b62b1451f71c29d24e11202498837e"
    end
  end

  def install
    # we have to do this because most build scripts assume that all sdl modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl2.pc.in sdl2-config.in], "@prefix@", HOMEBREW_PREFIX

    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head? || build.devel?

    args = %W[--prefix=#{prefix}]

    # LLVM-based compilers choke on the assembly code packaged with SDL.
    if ENV.compiler == :clang && DevelopmentTools.clang_build_version < 421
      args << "--disable-assembly"
    end
    args << "--without-x"
    args << "--disable-haptic" << "--disable-joystick" if MacOS.version <= :snow_leopard

    system "./configure", *args
    system "make", "install"

    if build.with? "test"
      ENV.prepend_path "PATH", bin
      # We need the build to point at the newly-built (not yet linked) copy of SDL.
      inreplace bin/"sdl2-config", "prefix=#{HOMEBREW_PREFIX}", "prefix=#{prefix}"
      cd "test" do
        system "./configure", "--without-x"
        system "make"
        # Tests don't have a "make install" target
        (share/"tests").install %w[checkkeys controllermap loopwave loopwavequeue testaudioinfo
                                   testerror testfile testgl2 testiconv testjoystick testkeys
                                   testloadso testlock testmultiaudio testoverlay2 testplatform
                                   testsem testshape testsprite2 testthread testtimer testver
                                   testwm2 torturethread]
        (share/"test_extras").install %w[axis.bmp button.bmp controllermap.bmp icon.bmp moose.dat
                                         picture.xbm sample.bmp sample.wav shapes]
        bin.write_exec_script Dir["#{share}/tests/*"]
      end
      # Point sdl-config back at the normal prefix once we've built everything.
      inreplace bin/"sdl2-config", "prefix=#{prefix}", "prefix=#{HOMEBREW_PREFIX}"
    end
  end

  test do
    system bin/"sdl2-config", "--version"
  end
end
