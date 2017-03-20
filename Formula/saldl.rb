class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview."
  homepage "https://saldl.github.io/"
  url "https://github.com/saldl/saldl/archive/v35.tar.gz"
  sha256 "6b5f45a8f7782bcad124df4a24876c8b3c47d45aa25d0b09b2030837c6ece82c"

  head "https://github.com/saldl/saldl.git", :shallow => false

  bottle do
    cellar :any
    rebuild 1
    sha256 "5473924f9201caebcf443d9263f5388097fd44ad623716ff89d42154834c10b1" => :sierra
    sha256 "cba7f441ad4df16c9bc179914d1be6e4dd495ec1539f1e985df247ec8197fe57" => :el_capitan
    sha256 "f246214e2ff8239f59c0fafa4c839d95a8c9078cb25829fda09ca9cdbb31ec14" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libevent"

  if MacOS.version <= :mavericks
    # curl >= 7.42 is required
    depends_on "curl"
  else
    depends_on "curl" => :optional
  end

  def install
    ENV.refurbish_args

    # a2x/asciidoc needs this to build the man page successfully
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = ["--prefix=#{prefix}"]

    # head uses git describe to acquire a version
    args << "--saldl-version=v#{version}" unless build.head?

    system "./waf", "configure", *args
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system "#{bin}/saldl", "https://brew.sh/index.html"
    assert File.exist? "index.html"
  end
end
