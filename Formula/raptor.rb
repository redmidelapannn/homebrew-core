class Raptor < Formula
  desc "RDF parser toolkit"
  homepage "http://librdf.org/raptor/"
  url "http://download.librdf.org/source/raptor2-2.0.15.tar.gz"
  sha256 "ada7f0ba54787b33485d090d3d2680533520cd4426d2f7fb4782dd4a6a1480ed"

  bottle do
    cellar :any
    rebuild 1
    sha256 "af05617744912dc8a21f89d453878ae906984fbb62afb23b3d8bc712c1ae1336" => :catalina
    sha256 "baa946053e88fa6ea45058b54f73715d95c0304d0e222f92d3f292f57b5fc384" => :mojave
    sha256 "e4fe52ab17b804ad864fbfd1ca79d0027fe0b55833649276a3bac7b9664ddae1" => :high_sierra
  end

  uses_from_macos "libxml2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
