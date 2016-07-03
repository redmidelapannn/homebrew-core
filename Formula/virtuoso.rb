class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.1/virtuoso-opensource-7.2.1.tar.gz"
  mirror "https://downloads.sourceforge.net/project/virtuoso/virtuoso/7.2.1/virtuoso-opensource-7.2.1.tar.gz"
  sha256 "8e680173f975266046cdc33b0949c6c3320b82630288aed778524657a32ee094"

  bottle do
    cellar :any
    revision 1
    sha256 "943549b89a08758fbd81082895cc45ef0badb2d48e143c389b288782f7be86a0" => :el_capitan
    sha256 "398e110e7999fc20e83e9affaee24fe04c937131031e83205d1a6edf1f244013" => :yosemite
    sha256 "ce3bb634afdad5219a44720c99a18502d1602a3a97b80c912d7db2a56821f851" => :mavericks
  end

  head do
    url "https://github.com/openlink/virtuoso-opensource.git", :branch => "develop/7"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "openssl"

  conflicts_with "unixodbc", :because => "Both install `isql` binaries."

  skip_clean :la

  def install
    ENV.m64 if MacOS.prefer_64_bit?
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    NOTE: the Virtuoso server will start up several times on port 1111
    during the install process.
    EOS
  end

  test do
    system bin/"virtuoso-t", "+checkpoint-only"
  end
end
