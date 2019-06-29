class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://bitbucket.org/wez/atomicparsley/overview/"
  url "https://bitbucket.org/wez/atomicparsley/get/0.9.6.tar.bz2"
  sha256 "e28d46728be86219e6ce48695ea637d831ca0170ca6bdac99810996a8291ee50"
  revision 1
  head "https://bitbucket.org/wez/atomicparsley", :using => :hg

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "77a60e90347f05721ef5e73f4142d38cb35267dc01ce037943ccbf2bec81696e" => :mojave
    sha256 "a3287363216f748ff4857b99c284f65876532ff108ffa8b8f5dca98989d4b16b" => :high_sierra
    sha256 "59c5d8750269ca54c1440af6b5f4db7d8a77cbb5f0bfcce1b298eff1c9513dde" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  uses_from_macos "zlib"

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
    system "#{bin}/AtomicParsley", testpath/"file.m4a", "--artist", "Homebrew", "--overWrite"
    output = shell_output("#{bin}/AtomicParsley file.m4a --textdata")
    assert_match "Homebrew", output
  end
end
