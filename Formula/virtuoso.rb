class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.4.2/virtuoso-opensource-7.2.4.2.tar.gz"
  mirror "https://downloads.sourceforge.net/project/virtuoso/virtuoso/7.2.4.2/virtuoso-opensource-7.2.4.2.tar.gz"
  sha256 "028075d3cf1970dbb9b79f660c833771de8be5be7403b9001d6907f64255b889"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5228701fb175d3bfc6f6079ca6cb86be7db77e61ebb017b72eac3f08be29cc87" => :sierra
    sha256 "6006de044b8932dd2c12b3b4d4d47274c97d1140c4a04326e483a54e0fad978e" => :el_capitan
    sha256 "1f5f112d3b1862ba2e6630d75df7b8bf00cbdf7eebc613fd28e3c2fdd0e3fb8d" => :yosemite
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
