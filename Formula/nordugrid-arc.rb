class NordugridArc < Formula
  desc "Grid computing middleware"
  homepage "http://www.nordugrid.org/"
  url "http://download.nordugrid.org/packages/nordugrid-arc/releases/5.0.2/src/nordugrid-arc-5.0.2.tar.gz"
  sha256 "d7306d91b544eeba571ede341e43760997c46d4ccdacc8b785c64f594780a9d1"

  bottle do
    rebuild 1
    sha256 "558a1f17882e6ab98421d5203aca6f039625c1abd8e226666df1ac768721dc12" => :high_sierra
    sha256 "f3ab130f52d4d54cd89dc32bb74f13d13c6423c31961948dae6c7944e28aeb49" => :sierra
    sha256 "a1b208bfe2bb26c47135d4beb2e57644a1ce14b2706f02f3d052338856d2f464" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "glibmm"
  depends_on "libxml2"
  depends_on "globus-toolkit"

  needs :cxx11

  # build fails on Mavericks due to a clang compiler bug
  # and bottling also fails if gcc is being used due to conflicts between
  # libc++ and libstdc++
  depends_on :macos => :yosemite

  # bug filed upstream at https://bugzilla.nordugrid.org/show_bug.cgi?id=3514
  patch do
    url "https://gist.githubusercontent.com/tschoonj/065dabc33be5ec636058/raw/beee466cdf5fe56f93af0b07022532b1945e9d2e/nordugrid-arc.diff"
    sha256 "5561ea013ddd03ee4f72437f2e01f22b2c0cac2806bf837402724be281ac2b6d"
  end

  fails_with :clang do
    build 500
    cause "Fails with 'template specialization requires \"template<>\"'"
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-swig",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write("data")
    system "#{bin}/arccp", "foo", "bar"
  end
end
