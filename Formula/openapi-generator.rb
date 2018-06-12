class OpenapiGenerator < Formula
  desc "Generate clients, server & docs from an OpenAPI spec (v2, v3)"
  homepage "https://openapi-generator.tech"
  url "https://github.com/OpenAPITools/openapi-generator/archive/v3.0.1.tar.gz"
  sha256 "348f0163733a0bea9afedde1b75dd27bb51fba348b5e56edceff4663f32f346f"

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
