class Autogen < Formula
  desc "Automated text file generator"
  homepage "https://autogen.sourceforge.io"
  url "https://ftpmirror.gnu.org/autogen/autogen-5.18.7.tar.xz"
  mirror "https://ftp.gnu.org/gnu/autogen/autogen-5.18.7.tar.xz"
  sha256 "a7a580a5e18931cb341b255cec2fee2dfd81bea5ddbf0d8ad722703e19aaa405"

  bottle do
    rebuild 1
    sha256 "2c1ecc3356d6dd598e7a468e83eb4ebdfed6a15fbc953f2b5f233210e99540c2" => :sierra
    sha256 "5b66d1701e6d7393e594672a776382c71a3908a2b823770a3f225cdd6db786b0" => :el_capitan
    sha256 "a69c54122b26ac150045e27a03fef56a805901c5194c630f2f856167a1c6b303" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "guile"

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
