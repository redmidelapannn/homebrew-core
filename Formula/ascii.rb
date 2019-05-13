class Ascii < Formula
  desc "List ASCII idiomatic names and octal/decimal code-point forms"
  homepage "http://www.catb.org/~esr/ascii/"
  url "http://www.catb.org/~esr/ascii/ascii-3.18.tar.gz"
  sha256 "728422d5f4da61a37a17b4364d06708e543297de0a5f70305243236d80df072d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "098d2fbfd1e81db09711b37e31a9d820c304987fcd4f96782e74683beb64b164" => :mojave
  end

  head do
    url "https://gitlab.com/esr/ascii.git"
    depends_on "xmlto" => :build
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.head?
    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Official name: Line Feed", shell_output(bin/"ascii 0x0a")
  end
end
