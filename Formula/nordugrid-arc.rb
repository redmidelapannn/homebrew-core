class NordugridArc < Formula
  desc "Grid computing middleware"
  homepage "http://www.nordugrid.org/"
  url "https://download.nordugrid.org/packages/nordugrid-arc/releases/6.1.0/src/nordugrid-arc-6.1.0.tar.gz"
  sha256 "dca3e212d7522ca443ad88180859fc24bc3058fa3e40f47508e50fe7918d6248"

  bottle do
    sha256 "d6631b3ea3af7b740cf7a3c53e39af92edfd986a65b5d31d14ea0a8bf87a5df3" => :mojave
    sha256 "c17fd651e7107745c336650da8fdd6b5e028f9ae21d01a80403b7dc67ff4a6c7" => :high_sierra
    sha256 "ac6b4407fd5137d71c9e88c3ffd0cdd97fa89c301afbd8e9f19b52981ceb1620" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "glibmm"
  depends_on "globus-toolkit"
  depends_on "libxml2"

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
