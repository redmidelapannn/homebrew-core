class PdfRedactTools < Formula
  desc "Securely redacting and stripping metadata"
  homepage "https://github.com/firstlookmedia/pdf-redact-tools"
  url "https://github.com/firstlookmedia/pdf-redact-tools/archive/v0.1.2.tar.gz"
  sha256 "5874a7b76be15ccaa4c20874299ef51fbaf520a858229a58678bc72a305305fc"
  revision 1
  head "https://github.com/firstlookmedia/pdf-redact-tools.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "06935cba640e4fe1aafa72df71fc6d90988853fdc18a1dc6ada275404c554ba5" => :catalina
    sha256 "e48994033d36307dd82011bc7da9c17e0e2438d5fc17448e9528a1b2b69009c9" => :mojave
    sha256 "e48994033d36307dd82011bc7da9c17e0e2438d5fc17448e9528a1b2b69009c9" => :high_sierra
  end

  depends_on "exiftool"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on :macos # Due to Python 2 (https://github.com/firstlookmedia/pdf-redact-tools/pull/34)

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # Modifies the file in the directory the file is placed in.
    cp test_fixtures("test.pdf"), "test.pdf"
    system bin/"pdf-redact-tools", "-e", "test.pdf"
    assert_predicate testpath/"test_pages/page-0.png", :exist?
    rm_rf "test_pages"

    system bin/"pdf-redact-tools", "-s", "test.pdf"
    assert_predicate testpath/"test-final.pdf", :exist?
  end
end
