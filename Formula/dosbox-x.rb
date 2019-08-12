class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.82.15.tar.gz"
  sha256 "60e196ee49e4532327d0786a9e3b4f1d28820906b0b868abecf89a19300fb3da"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "4046c873325d337d9329be969debca030eb834cb62bd8e0e0ada223688c760f4" => :mojave
    sha256 "4257e45cbf1ca9045f09d82084f9a3d3e44c259cab4cce38dcab754031752fdd" => :high_sierra
    sha256 "4c2a87e69862680388d9c8caf6e918adfc6a2bad77a2d9455302375dc9332daf" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "fluid-synth"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
    ]
    system "./build-macosx", *args
    system "make", "install"
  end

  test do
    assert_match /DOSBox version #{version}/, shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
