class Autogen < Formula
  desc "Automated text file generator"
  homepage "https://autogen.sourceforge.io"
  url "https://ftp.gnu.org/gnu/autogen/rel5.18.12/autogen-5.18.12.tar.xz"
  mirror "https://ftpmirror.gnu.org/autogen/rel5.18.12/autogen-5.18.12.tar.xz"
  sha256 "be3ba62e883185b6ee8475edae97d7197d701d6b9ad9c3d2df53697110c1bfd8"
  revision 1

  bottle do
    rebuild 1
    sha256 "9941c24a9562da2ece7d03bb4d77992b121c43be17b6bca17a6db84cd3018957" => :mojave
    sha256 "554153c1f09e0d6b3a3e1999774bebb85c61410e4076185cc37803c9d80e0e2e" => :high_sierra
    sha256 "f861bcf37c91952ed131b69b8ae57485d14dc22868c22bceb715bb4e76206131" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "libxml2"

  # Allow guile 2.2 to be used
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0de886b/autogen/allow-guile-2.2.diff"
    sha256 "438fe673432c96d5da449b84daa4d1c6ad238ea0b4ccd13491872df8c51fa978"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    # make and install must be separate steps for this formula
    system "make"
    system "make", "install"
  end

  test do
    system bin/"autogen", "-v"
  end
end
