class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.0.9/pdftk-v3.0.9.tar.gz"
  sha256 "8210167286849552eff08199e7734223c6ae9b7f1875e4e2b5b6e7996514dd10"
  head "https://gitlab.com/pdftk-java/pdftk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7eabc27392f5ebec39be8ef65b27bb3d3f6c35746d6407785e1f5bc6e187b3f2" => :catalina
    sha256 "78a52f69bd06e41107c8dfd6b9c181cabfed9cff56953781b17675d037111229" => :mojave
    sha256 "351434eed0eb691ecfa417cbccfabed6a12411fe05b03af6eb47588e46af7d46" => :high_sierra
  end

  depends_on "gradle" => :build
  depends_on :java => "1.8"

  def install
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/pdftk-all.jar"
    bin.write_jar_script libexec/"pdftk-all.jar", "pdftk", :java_version => "1.8"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output_path = testpath/"output.pdf"
    system bin/"pdftk", pdf, pdf, "cat", "output", output_path
    assert output_path.read.start_with?("%PDF")
  end
end
