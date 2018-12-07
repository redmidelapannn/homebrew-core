class AwsApigatewayImporter < Formula
  desc "AWS API Gateway Importer"
  homepage "https://github.com/amazon-archives/aws-apigateway-importer"
  url "https://github.com/amazon-archives/aws-apigateway-importer/archive/aws-apigateway-importer-1.0.1.tar.gz"
  sha256 "8371e3fb1b6333cd50a76fdcdc1280ee8e489aec4bf9a1869325f9b8ebb73b54"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5965799e63fd96093f0ac7931578992fb915b7ed4e91e3bfdd9456cb217278da" => :mojave
    sha256 "88fc2a6a7652b5004bfd3342cb1e73287355c76d585dbfbbe6e2587fbf4c4465" => :high_sierra
    sha256 "9ee86f25fd3f6603faaf48a2bd0c2f13542bb32a68527b1cfb8fcab6803706ba" => :sierra
  end

  depends_on "maven" => :build
  depends_on :java => "1.8"

  # Pin aws-sdk-java-core for JSONObject compatibility
  patch do
    url "https://github.com/amazon-archives/aws-apigateway-importer/commit/660e3ce.diff?full_index=1"
    sha256 "6ff63c504b906e1fb6d0f2a9772761edeef3b37b3dca1e48bba72432d863a852"
  end

  def install
    system "mvn", "assembly:assembly"
    libexec.install "target/aws-apigateway-importer-1.0.1-jar-with-dependencies.jar"
    bin.write_jar_script libexec/"aws-apigateway-importer-1.0.1-jar-with-dependencies.jar", "aws-api-import"
  end

  test do
    assert_match(/^Usage:\s+aws-api-import/, shell_output("#{bin}/aws-api-import --help"))
  end
end
