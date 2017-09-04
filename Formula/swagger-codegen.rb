class SwaggerCodegen < Formula
  desc "Generation of client and server from Swagger definition"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.2.3.tar.gz"
  sha256 "433c295891d0fd51f507b94071f7b8507a955ee74fc5ab6ba2c9d309562dbf69"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "00ea88536dfda10671768f496083137ed123477a02ad332c38af3e842e8c6708" => :sierra
    sha256 "30f8bd432ef29a73d1c5c8c8691896dcc3252568a186d75c1d099fd8722ddb29" => :el_capitan
    sha256 "1d27e2b3a5a495e86128aea131e8e524423ae11fabf133ebdd10b3fee0fff566" => :yosemite
  end

  depends_on :java => "1.7+"
  depends_on "maven" => :build

  def install
    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen"
  end

  test do
    (testpath/"minimal.yaml").write <<-EOS.undent
      ---
      swagger: '2.0'
      info:
        version: 0.0.0
        title: Simple API
      paths:
        /:
          get:
            responses:
              200:
                description: OK
    EOS
    system "#{bin}/swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "swagger"
  end
end
