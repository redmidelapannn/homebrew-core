class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.13.1.tar.gz"
  sha256 "c8725d78e43b7d6a04465e8a156bc4c6a78121f291aac74e0b0a10286ef95544"

  bottle do
    cellar :any
    sha256 "a3eaaa34fca0278198b8ca65836fb0b0406d83388ae143f3a683c9f74ecf1440" => :catalina
    sha256 "e553c2c499cb93fef0f8d72548387ad9a8b8253e174af53b0249f3306ef27433" => :mojave
    sha256 "35906abb4f6868ba0a045e10ec7eb70a94c54c14932330ab798758a227c12e34" => :high_sierra
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
