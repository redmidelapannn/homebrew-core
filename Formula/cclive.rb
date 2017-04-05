class Cclive < Formula
  desc "Command-line video extraction utility"
  homepage "https://cclive.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cclive/0.7/cclive-0.7.16.tar.xz"
  sha256 "586a120faddcfa16f5bb058b5c901f1659336c6fc85a0d3f1538882a44ee10e1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0be9b0a6193831daabb000af5a93e95609ca95ff63bfe623da85ea8df0cd47f2" => :sierra
    sha256 "e95b6a98cbef156e57ca141388b3bf69d89e1bdc8457a304d4b0c3a5cb266bff" => :el_capitan
    sha256 "b39563ec298159f5b9fe79fffa72390441c0ae49c552f285d24562787bfc2e1d" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "quvi"
  depends_on "boost"
  depends_on "pcre"

  conflicts_with "clozure-cl", :because => "both install a ccl binary"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    url = "https://youtu.be/VaVZL7F6vqU"
    output = shell_output("#{bin}/cclive --no-download #{url} 2>&1")
    assert_match "Martin Luther King Jr Day", output
  end
end
