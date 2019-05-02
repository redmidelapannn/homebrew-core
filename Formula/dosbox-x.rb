class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "http://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.82.16.tar.gz"
  sha256 "48ed04d08b4fd8cd8d388048280c4d98f9f202ea996d4b14c340e68693406c77"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    sha256 "5142e3fa30753a611ba6d6a16e38d74c438d7ffe2ce2dd49aea127fc6adf811c" => :mojave
    sha256 "e81a4ccb27443dac36af88c75ede0c8fdc45eb6cfa8ac7d3ef88f8b079db11d0" => :high_sierra
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
