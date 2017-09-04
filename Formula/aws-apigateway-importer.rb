class AwsApigatewayImporter < Formula
  desc "AWS API Gateway Importer"
  homepage "https://github.com/awslabs/aws-apigateway-importer"
  url "https://github.com/awslabs/aws-apigateway-importer/archive/aws-apigateway-importer-1.0.1.tar.gz"
  sha256 "1aecfd348135c2e364ce5e105d91d5750472ac4cb8848679d774a2ac00024d26"
  revision 1

  # Pin aws-sdk-java-core for JSONObject compatibility
  patch do
    url "https://github.com/awslabs/aws-apigateway-importer/commit/660e3ce.diff?full_index=1"
    sha256 "6ff63c504b906e1fb6d0f2a9772761edeef3b37b3dca1e48bba72432d863a852"
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3b7f6a876a4239ecc14bd6266a48f61146af667828ba6031c6054fed63839b5d" => :sierra
    sha256 "2d83424857d75f2d55ea1d835582dc7d71bf378c8ed3065f00798b9546bab687" => :el_capitan
    sha256 "c0c7e20e6d9fcedb163343eee4ea0a64b7786fcd69ce53460514448ecb5d85ee" => :yosemite
  end

  depends_on :java => "1.7+"
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
