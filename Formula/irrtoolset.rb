class Irrtoolset < Formula
  desc "Tools to work with Internet routing policies"
  homepage "https://github.com/irrtoolset/irrtoolset"
  url "https://ftp.isc.org/isc/IRRToolSet/IRRToolSet-5.0.1/irrtoolset-5.0.1.tar.gz"
  sha256 "c044e4e009bf82db84f6a4f4d5ad563b07357f2d0e9f0bbaaf867e9b33fa5e80"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "f37b83b466916a4bb2660952c3d2c23c6aa22a769cd225624dca4d6a02c95981" => :el_capitan
    sha256 "bf77c22168264d5d70005ec7825eb94587ad967243720a0c47bfdb2941e4fdb7" => :yosemite
    sha256 "4f332593b4219376c3c5b96215cf02e13d926260a652b21bd536af7211882d0c" => :mavericks
  end

  head do
    url "svn://irrtoolset.isc.org/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  def install
    if build.head?
      system "glibtoolize"
      system "autoreconf", "-i"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/peval", "ANY"
  end
end
