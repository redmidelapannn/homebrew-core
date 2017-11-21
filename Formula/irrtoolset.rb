class Irrtoolset < Formula
  desc "Tools to work with Internet routing policies"
  homepage "https://github.com/irrtoolset/irrtoolset"
  url "https://ftp.isc.org/isc/IRRToolSet/IRRToolSet-5.0.1/irrtoolset-5.0.1.tar.gz"
  sha256 "c044e4e009bf82db84f6a4f4d5ad563b07357f2d0e9f0bbaaf867e9b33fa5e80"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "93a58b3888ade1fcdcea8631f9e019b9c60c5c542e92e133840db8942786b988" => :high_sierra
    sha256 "938917024896260f75c31c3fdd8b54c66631d55fb97d2eabdbc0c43a1681bea3" => :sierra
    sha256 "d33f653f2b479e4d31c5d33f344b8a7690c55b873ff40054e4850fbe174235f0" => :el_capitan
  end

  head do
    url "https://github.com/irrtoolset/irrtoolset.git"

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
