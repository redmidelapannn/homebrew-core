class Genometools < Formula
  desc "GenomeTools: The versatile open source genome analysis software"
  homepage "http://genometools.org/"
  url "http://genometools.org/pub/genometools-1.5.10.tar.gz"
  sha256 "0208591333b74594bc219fb67f5a29b81bb2ab872f540c408ac1743716274e6a"
  revision 1
  head "https://github.com/genometools/genometools.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7f2a9fda52627ec43e8d00da08dddd7214ddcf8b825c28d1fb9209f4ef0a3d38" => :high_sierra
    sha256 "f6067f8dfb360a499881f4d33a924652e611c081b911d850e94e2967c9f83819" => :sierra
    sha256 "6dbb3b4e6bef0d07dad4c63753b072ba0c925308e1d303c85b2be94672a44df8" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "pango"
  depends_on "python@2"

  conflicts_with "libslax", :because => "both install `bin/gt`"

  def install
    system "make", "prefix=#{prefix}"
    system "make", "install", "prefix=#{prefix}"

    cd "gtpython" do
      # Use the shared library from this specific version of genometools.
      inreplace "gt/dlload.py",
        "gtlib = CDLL(\"libgenometools\" + soext)",
        "gtlib = CDLL(\"#{lib}/libgenometools\" + soext)"

      system "python", *Language::Python.setup_install_args(prefix)
      system "python", "-m", "unittest", "discover", "tests"
    end
  end

  test do
    system "#{bin}/gt", "-test"
    system "python2.7", "-c", "import gt"
  end
end
