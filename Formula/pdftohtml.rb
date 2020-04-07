class Pdftohtml < Formula
  desc "PDF to HTML converter (based on xpdf)"
  homepage "https://pdftohtml.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pdftohtml/Experimental%20Versions/pdftohtml%200.40/pdftohtml-0.40a.tar.gz"
  sha256 "277ec1c75231b0073a458b1bfa2f98b7a115f5565e53494822ec7f0bcd8d4655"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "86fc0fc1ec7a2b860c778cf8a55240e6aeb3d337ed68e844ef7c7e3e4cb5ca79" => :catalina
    sha256 "cd9998cd6678310dcbf827fc2257b5fd0de706e7fb2457e9a11e1bb0f6e83d95" => :mojave
    sha256 "03c3bfbbc04d6e04339045ca8819637b37e645c1095934640f9851826d4590d2" => :high_sierra
  end

  conflicts_with "pdf2image", "poppler", "xpdf",
    :because => "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  def install
    system "make"
    bin.install "src/pdftohtml"
  end
end
