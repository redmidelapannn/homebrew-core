class Cclive < Formula
  desc "Command-line video extraction utility"
  homepage "http://cclive.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cclive/0.7/cclive-0.7.16.tar.xz"
  sha256 "586a120faddcfa16f5bb058b5c901f1659336c6fc85a0d3f1538882a44ee10e1"
  revision 1

  bottle do
    cellar :any
    sha256 "273441a64326136bffc5c7d89d2880ccd5b2ddc62f6d0efb735ecf4f2021b651" => :sierra
    sha256 "3f34bf533713f8ef2852efa619b90077ab05e6d746f7fe1a59b66d011395c45e" => :el_capitan
    sha256 "6cc79d682c46ede8ddde316fffa3cbb1bb1fccbe51da6d3e56fdaa30123f76db" => :yosemite
  end

  conflicts_with "clozure-cl", :because => "both install a ccl binary"

  depends_on "pkg-config" => :build
  depends_on "quvi"
  depends_on "boost@1.61"
  depends_on "pcre"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
