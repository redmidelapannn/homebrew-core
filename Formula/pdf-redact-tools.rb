class PdfRedactTools < Formula
  desc "Securely redacting and stripping metadata"
  homepage "https://github.com/firstlookmedia/pdf-redact-tools"
  url "https://github.com/firstlookmedia/pdf-redact-tools/archive/v0.1.2.tar.gz"
  sha256 "5874a7b76be15ccaa4c20874299ef51fbaf520a858229a58678bc72a305305fc"
  head "https://github.com/firstlookmedia/pdf-redact-tools.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "69f59c27f26321ef5f1da0e8a7d93a4fb2cba1c79fb63a79a6d7d150f5680866" => :mojave
    sha256 "dca4476c7afcfb79ee6cc03cb95515604e0d03b6ef320092f38dbc99c846f432" => :high_sierra
    sha256 "dca4476c7afcfb79ee6cc03cb95515604e0d03b6ef320092f38dbc99c846f432" => :sierra
    sha256 "dca4476c7afcfb79ee6cc03cb95515604e0d03b6ef320092f38dbc99c846f432" => :el_capitan
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
