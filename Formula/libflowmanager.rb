class Libflowmanager < Formula
  desc "Flow-based measurement tasks with packet-based inputs"
  homepage "https://research.wand.net.nz/software/libflowmanager.php"
  url "https://research.wand.net.nz/software/libflowmanager/libflowmanager-2.0.5.tar.gz"
  sha256 "00cae0a13ac0a486a6b8db2c98a909099fd22bd8e688571e2833cf3ee7ad457e"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "6dc74e2a1b0c9711ff5f3b58b0901d8f544e903079bf8262b01a77f59753932c" => :sierra
    sha256 "9b633342771f4fd1ebe379876781c7ee9b5b293d95622b295cf11b9a2390ce1e" => :el_capitan
    sha256 "179e109f434a0e81b2ab74ce2ff759d2a986626406361e2805233bb354515653" => :yosemite
  end

  depends_on "libtrace"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
