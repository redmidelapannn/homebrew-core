class Pla < Formula
  desc "Tool for building Gantt charts in PNG, EPS, PDF or SVG format"
  homepage "https://www.arpalert.org/pla.html"
  url "https://www.arpalert.org/src/pla-1.2.tar.gz"
  sha256 "c2f1ce50b04032abf7f88ac07648ea40bed2443e86e9f28f104d341965f52b9c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c67cb283c41049d04ae84e7f3ea8b93bb8d0d9382862bc3a2aba71b3dfe42b10" => :sierra
    sha256 "33c2fec742a5d53f879178cabeaa0f17ec856c64b24c086ef06a66b79b669be4" => :el_capitan
    sha256 "228ffd735c2db2e08618fc8d544fd93fa31c1bd23cd815bd789020609d684619" => :yosemite
  end

  depends_on "cairo"
  depends_on "pkg-config" => :build

  def install
    system "make"
    bin.install "pla"
  end

  test do
    (testpath/"test.pla").write <<-EOS.undent
    [4] REF0 Install des serveurs
      color #8cb6ce
      child 1
      child 2
      child 3

      [1] REF0 Install 1
        start 2010-04-08 01
        duration 24
        color #8cb6ce
        dep 2
        dep 6
        EOS
    system "#{bin}/pla", "-i", "#{testpath}/test.pla", "-o test"
  end
end
