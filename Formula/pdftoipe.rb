class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.8.1.tar.gz"
  sha256 "a6174aae72f93b56c6652c2c27d5203e0f867e11a5e1c7d89c4aa3b4bcb67eb3"
  revision 8

  bottle do
    cellar :any
    sha256 "a38c3427e306bb9726ebcc36724bbdaa454f926fe374f373e2f7251ff44f81f2" => :catalina
    sha256 "cddd349c9f60dad625088d77502c7790061f05d72f3efdbad0fcea1ba3dc709f" => :mojave
    sha256 "59d70b89805c9713ab034d69f470d554e6911fdb7932a299e3d11c79c8457715" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
    ENV.cxx11

    cd "pdftoipe" do
      system "make"
      bin.install "pdftoipe"
      man1.install "pdftoipe.1"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin/"pdftoipe", "test.pdf"
    assert_match "Homebrew test.</text>", File.read("test.ipe")
  end
end
