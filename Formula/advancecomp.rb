class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "https://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/releases/download/v2.1/advancecomp-2.1.tar.gz"
  sha256 "3ac0875e86a8517011976f04107186d5c60d434954078bc502ee731480933eb8"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "77837f378fa11d8d72b0067d66d87750d925529cb94fe710e723b4db8cf38793" => :mojave
    sha256 "f66f9d2b77f1077e27169aa99b74862c421655bc05237c501847c88e39aab610" => :high_sierra
    sha256 "cbd8ac85bd49d7add98f61e621c01737f7f200160f94bab63aad7ca35cf13e43" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--enable-bzip2", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"advdef", "--version"

    cp test_fixtures("test.png"), "test.png"
    system bin/"advpng", "--recompress", "--shrink-fast", "test.png"

    version_string = shell_output("#{bin}/advpng --version")
    assert_includes version_string, "advancecomp v#{version}"
  end
end
