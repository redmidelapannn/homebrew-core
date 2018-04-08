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
    sha256 "fc56f07a607f3c20373ed2bac30a0c5029fa4225ae535d6203cb8be203e0e651" => :high_sierra
    sha256 "7ebec9e489765f243fc775c638cf0f3397cc146a19d3b889d4ed4134e3c3c3c1" => :sierra
    sha256 "5ba8aa0dc6f680f0e68157ec7882b3a427e57304322d3317e6337950fbf4e302" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "pango"
  depends_on "python@2"

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
