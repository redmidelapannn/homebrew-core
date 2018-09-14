class Mftrace < Formula
  desc "Trace TeX bitmap font to PFA, PFB, or TTF font"
  homepage "http://lilypond.org/mftrace/"
  url "http://lilypond.org/downloads/sources/mftrace/mftrace-1.2.19.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/mftrace-1.2.19.tar.gz"
  sha256 "778126f4220aa31fc91fa8baafd26aaf8be9c5e8fed5c0e92a61de04d32bbdb5"
  revision 2

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0f52a0687f46318b5edf3b40a90ca7636d67c50687d40aa00f30f66e8584ba2a" => :mojave
    sha256 "421a79a739f9f65bc13f769a70cb14cb5a8836fcbe525c4a786f9192f49601d9" => :high_sierra
    sha256 "bd6ec9b6f3b0e2890599a057c4caf11a27d1429ec70edff9792a656e8be7dfe2" => :sierra
    sha256 "3d7af07230b3a1dc83e412af2555495483b35dd044058086b35d874544896c0c" => :el_capitan
  end

  head do
    url "https://github.com/hanwen/mftrace.git"
    depends_on "autoconf" => :build
  end

  depends_on "fontforge"
  depends_on "potrace"
  depends_on "t1utils"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mftrace", "--version"
  end
end
