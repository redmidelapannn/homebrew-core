class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.3.0/libfabric-1.3.0.tar.bz2"
  sha256 "0a0d4f1a0d178d80ec336763a0fd371ade97199d6f1e884ef8f0e6bc99f258c9"

  bottle do
    revision 1
    sha256 "ef7c7ba2a746c746f15c8f5ae12b23680ec2a500a0cda6c0d243171751f5ecf3" => :el_capitan
    sha256 "de3f055db9b2f3791544f53e9de99cbe429d0dc3fbaf4f6047a0519c48fa178e" => :yosemite
    sha256 "f2cc1bc59fbae7bbd846d6fc21aa8f3e6022289858317f9bdbbdaf52ba0cd982" => :mavericks
  end

  head do
    url "https://github.com/ofiwg/libfabric.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#(bin}/fi_info"
  end
end
