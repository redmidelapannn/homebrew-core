class Autogen < Formula
  desc "Automated text file generator"
  homepage "https://autogen.sourceforge.io"
  url "https://ftp.gnu.org/gnu/autogen/rel5.18.14/autogen-5.18.14.tar.xz"
  mirror "https://ftpmirror.gnu.org/autogen/rel5.18.14/autogen-5.18.14.tar.xz"
  sha256 "ffc7ab99382116852fd4c73040c124799707b2d9b00a60b54e8b457daa7a06e4"

  bottle do
    sha256 "0e2ce9a3228850cc175ef0e8cb8aaacdec87b4ff40ee762fa53cb9d948559fa3" => :sierra
    sha256 "319754a4173c4a2b72f4002fac475899be2f70fce0a0b4ad923cc5c37b077196" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "guile"

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
