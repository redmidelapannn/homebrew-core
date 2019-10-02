class Idml < Formula
  desc "Ingestion Data Mapping Language"
  homepage "http://idml.io"
  url "https://github.com/IDML/idml/releases/download/v2.0.0/idml.jar"
  sha256 "59a13e8b112bf91e2c0dd44349c00ffb8cedf61272c27d2a4fbf633f6f132fa8"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f4d95c5fd7ee194479f135ce13b73780f44af45e8f7b40e9fc92fcd23a9a249" => :catalina
    sha256 "4f4d95c5fd7ee194479f135ce13b73780f44af45e8f7b40e9fc92fcd23a9a249" => :mojave
    sha256 "4f4d95c5fd7ee194479f135ce13b73780f44af45e8f7b40e9fc92fcd23a9a249" => :high_sierra
  end

  def install
    libexec.install "idml.jar"
    bin.write_jar_script libexec/"idml.jar", "idml"
  end

  test do
    idml_version = shell_output("unzip -p #{libexec}/idml.jar META-INF/MANIFEST.MF | sed -nEe '/Specification-Version:/p'")
    assert_equal "Specification-Version: #{version}", idml_version.strip
  end
end
