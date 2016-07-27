class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.4.2/virtuoso-opensource-7.2.4.2.tar.gz"
  mirror "https://downloads.sourceforge.net/project/virtuoso/virtuoso/7.2.4.2/virtuoso-opensource-7.2.4.2.tar.gz"
  sha256 "028075d3cf1970dbb9b79f660c833771de8be5be7403b9001d6907f64255b889"

  bottle do
    cellar :any
    revision 1
    sha256 "dc6b7299392ab4a498e670026f56a20309feb5586ec78612dc683a0795fc82ff" => :el_capitan
    sha256 "c5cb1c807630bbd9d1eb9d4bf524bf09a59e9b43e7d813593d8b88d2c25ca681" => :yosemite
    sha256 "a3e5850f8336522c5f349f2814802557c44308364d7fbc36a513bf091832433c" => :mavericks
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
