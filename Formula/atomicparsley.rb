class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://bitbucket.org/wez/atomicparsley/overview/"
  url "https://bitbucket.org/dinkypumpkin/atomicparsley/downloads/atomicparsley-0.9.6.tar.bz2"
  sha256 "49187a5215520be4f732977657b88b2cf9203998299f238067ce38f948941562"
  head "https://bitbucket.org/wez/atomicparsley", :using => :hg

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "15feef2329bd8afe6cbf6ac1b98faa0dc1497cd291132ce6fc4727e381be4dd6" => :sierra
    sha256 "069612002925e4a3b3e0283512cb0d6b4b1d7b269e07e9f58e57d62a2b101c83" => :el_capitan
    sha256 "f9c26a7cb5d69285d90fe9ab49ba9a1569badfdd53eb6be2b80b588238fec135" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Fix Xcode 9 pointer warnings
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
end
