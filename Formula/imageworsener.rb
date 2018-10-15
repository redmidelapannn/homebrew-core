class Imageworsener < Formula
  desc "Utility and library for image scaling and processing"
  homepage "https://entropymine.com/imageworsener/"
  url "https://entropymine.com/imageworsener/imageworsener-1.3.2.tar.gz"
  sha256 "0946f8e82eaf4c51b7f3f2624eef89bfdf73b7c5b04d23aae8d3fbe01cca3ea2"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "4369e7ce0641444406da6178631ef7de6eb332752cc103fbed9c868f5bf16c28" => :mojave
    sha256 "7185c18adbbdfb6176ff84db0fc5f8dcb00ce49eb5267e602cf029a3328b954d" => :high_sierra
    sha256 "894a796085ebacb8316b26463ec085c3b4968cd1d8c0b8dbc3db7eb082213218" => :sierra
  end

  head do
    url "https://github.com/jsummers/imageworsener.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg"
  depends_on "libpng"

  def install
    if build.head?
      inreplace "./scripts/autogen.sh", "libtoolize", "glibtoolize"
      system "./scripts/autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--without-webp"
    system "make", "install"
    pkgshare.install "tests"
  end

  test do
    cp_r Dir["#{pkgshare}/tests/*"], testpath
    system "./runtest", bin/"imagew"
  end
end
