class PdfRedactTools < Formula
  desc "Securely redacting and stripping metadata"
  homepage "https://github.com/firstlookmedia/pdf-redact-tools"
  url "https://github.com/firstlookmedia/pdf-redact-tools/archive/v0.1.2.tar.gz"
  sha256 "5874a7b76be15ccaa4c20874299ef51fbaf520a858229a58678bc72a305305fc"
  head "https://github.com/firstlookmedia/pdf-redact-tools.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7f4cc061c064c274ea85f4071f24c60307a94333619715e7001730afb919d174" => :high_sierra
    sha256 "7f4cc061c064c274ea85f4071f24c60307a94333619715e7001730afb919d174" => :sierra
    sha256 "7f4cc061c064c274ea85f4071f24c60307a94333619715e7001730afb919d174" => :el_capitan
  end

  depends_on "python@2"
  depends_on "imagemagick"
  depends_on "exiftool"
  depends_on "ghostscript"

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
