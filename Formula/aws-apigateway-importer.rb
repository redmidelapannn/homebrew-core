class AwsApigatewayImporter < Formula
  desc "AWS API Gateway Importer"
  homepage "https://github.com/awslabs/aws-apigateway-importer"
  url "https://github.com/awslabs/aws-apigateway-importer/archive/aws-apigateway-importer-1.0.1.tar.gz"
  sha256 "8371e3fb1b6333cd50a76fdcdc1280ee8e489aec4bf9a1869325f9b8ebb73b54"
  revision 1

  # Pin aws-sdk-java-core for JSONObject compatibility
  patch do
    url "https://github.com/awslabs/aws-apigateway-importer/commit/660e3ce.diff?full_index=1"
    sha256 "6ff63c504b906e1fb6d0f2a9772761edeef3b37b3dca1e48bba72432d863a852"
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6540eb59829e13175261c58d9650684aacf4aeacb7a7da3b4fbd03af8c2629e0" => :high_sierra
    sha256 "363c7406379e3ddaaa4790f5a0dd8e497c9020d957a7bcd9c9530d51052da30a" => :sierra
    sha256 "363c7406379e3ddaaa4790f5a0dd8e497c9020d957a7bcd9c9530d51052da30a" => :el_capitan
  end

  depends_on :java => "1.8"
  depends_on "maven" => :build

  def install
    system "mvn", "assembly:assembly"
    libexec.install "target/aws-apigateway-importer-1.0.1-jar-with-dependencies.jar"
    bin.write_jar_script libexec/"aws-apigateway-importer-1.0.1-jar-with-dependencies.jar", "aws-api-import"
  end

  test do
    assert_match(/^Usage:\s+aws-api-import/, shell_output("#{bin}/aws-api-import --help"))
  end
end
