class Genometools < Formula
  desc "GenomeTools: The versatile open source genome analysis software"
  homepage "http://genometools.org/"
  url "http://genometools.org/pub/genometools-1.5.10.tar.gz"
  sha256 "0208591333b74594bc219fb67f5a29b81bb2ab872f540c408ac1743716274e6a"
  head "https://github.com/genometools/genometools.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0a836fe5686ef5a3ceaf6b2cad6a74f6be5440429a60ade5ba7618adc59b48cd" => :high_sierra
    sha256 "e78e3a1fc57c55db372ede957648c9560f4e44951438168e09b44de411b58242" => :sierra
    sha256 "dca14267b810d94b5861e2778526e39098fdc7cf6c733c5d3f5d7777c3db4a44" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "pango"
  depends_on "python@2" if MacOS.version <= :snow_leopard

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
