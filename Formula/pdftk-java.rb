class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.0.9/pdftk-v3.0.9.tar.gz"
  sha256 "8210167286849552eff08199e7734223c6ae9b7f1875e4e2b5b6e7996514dd10"
  revision 1
  head "https://gitlab.com/pdftk-java/pdftk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f358637d2199923dc3acb7a608a86b209367f88067713182a0cae0284e6924f" => :catalina
    sha256 "0bf649ae6ed3a2e7251318be2c0a0f101b69858b51b8ea728a471a89c756b8e6" => :mojave
    sha256 "d3a9f2e19c7e0257ffe3c6c2b3d4c7d363db71af044015edf1b6977a4351d1cb" => :high_sierra
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
