class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-8.2.1/qpdf-8.2.1.tar.gz"
  sha256 "f445d3ebda833fe675b7551378f41fa1971cc6f7a7921bbbb94d3a71a404abc9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9d22ab810252aa75bb2cc61cd1f8458c57896a539bb25432dbc562f99bc6f578" => :mojave
    sha256 "3ce8cb69f2690a51514da6e48c77916c861ec2b0b311512183b3f375838302a5" => :high_sierra
    sha256 "dc31db1b6d3ce92b54a8d0fe1f96ea46d1f137dce9a1afd434e9a4020d17e4c5" => :sierra
  end

  depends_on "jpeg"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
