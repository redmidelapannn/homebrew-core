class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://bitbucket.org/wez/atomicparsley/overview/"
  url "https://bitbucket.org/dinkypumpkin/atomicparsley/downloads/atomicparsley-0.9.6.tar.bz2"
  sha256 "49187a5215520be4f732977657b88b2cf9203998299f238067ce38f948941562"
  head "https://bitbucket.org/wez/atomicparsley", :using => :hg

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "f9e4ab5683fddc9307ddea2e2eff79d4f2bae745c07d0d6806b45725079d8bc2" => :high_sierra
    sha256 "32df2eedc82dc1182a5392072130ab93e4b9493291a53b4f3b127d46c3ac41b6" => :sierra
    sha256 "9ae2a6f0411edefc11e5ee4985f837f2c14f174e31fb85ce2dd75485a0f0c9cd" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Fix Xcode 9 pointer warnings
  # https://bitbucket.org/wez/atomicparsley/issues/52/xcode-9-build-failure
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/ac8624c36e/atomicparsley/xcode9.patch"
      sha256 "15b87be1800760920ac696a93131cab1c0f35ce4c400697bb8b0648765767e5f"
    end
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-universal"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.m4a"), testpath/"file.m4a"
    system "#{bin}/atomicparsley", testpath/"file.m4a", "--artist", "Homebrew", "--overWrite"
    output = shell_output("#{bin}/atomicparsley file.m4a --textdata")
    assert_match "Homebrew", output
  end
end
