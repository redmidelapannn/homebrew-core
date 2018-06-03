class OpenapiGenerator < Formula
  desc "Generate clients, server & docs from an OpenAPI spec (v2, v3)"
  homepage "https://openapi-generator.tech"
  url "https://github.com/OpenAPITools/openapi-generator/archive/v3.0.0.tar.gz"
  sha256 "01b4fde626b96c66edd8be71c34027eeda9ad132cc03890e6f051f505e600207"

  bottle do
    cellar :any_skip_relocation
    sha256 "049206808ca9aaee80dd5ae643bad630989d97529eb6457064e9ca8a865703b1" => :high_sierra
    sha256 "ec38fd47ae0eb4363b48a4349457c514c46f90eb14fbc8b187eee6b8aa0d81b1" => :sierra
    sha256 "4c98536e312f3fe3363ed52480e23b30c25fcd6f941adad4c656ac36f131aa7b" => :el_capitan
  end

  depends_on "maven" => :build
  depends_on :java => "1.8"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

    system "mvn", "clean", "package"
    libexec.install "modules/openapi-generator-cli/target/openapi-generator-cli.jar"
    bin.write_jar_script libexec/"openapi-generator-cli.jar", "openapi-generator"
  end

  test do
    (testpath/"minimal.yaml").write <<~EOS
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
    system "#{bin}/openapi-generator", "generate", "-i", "minimal.yaml", "-l", "openapi"
  end
end
