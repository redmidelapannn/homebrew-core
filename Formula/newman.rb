require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-4.6.1.tgz"
  sha256 "7e2716579c63c44f3dcbecfdfb5dc6c5d45aa29dbff60515fe6c5c14eb995445"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3d163e2d5c4eaf9ea5cac55a1fa31a4afdf79ccb0e1e75444e700ca9699372c" => :catalina
    sha256 "e52e509d269b95d3858dcf54b0d17e1ea4670644fe8b9a828776f878a8b83e64" => :mojave
    sha256 "7d882b436888ab48ce82d2d0137bf161e52c5bc182a78a8ded74ae3258a77899" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    path = testpath/"test-collection.json"
    path.write <<~EOS
      {
        "info": {
          "_postman_id": "db95eac2-6e1c-48c0-8c3a-f83c5341d4dd",
          "name": "Homebrew",
          "description": "Homebrew formula test",
          "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
        },
        "item": [
          {
            "name": "httpbin-get",
            "request": {
              "method": "GET",
              "header": [],
              "body": {
                "mode": "raw",
                "raw": ""
              },
              "url": {
                "raw": "https://httpbin.org/get",
                "protocol": "https",
                "host": [
                  "httpbin",
                  "org"
                ],
                "path": [
                  "get"
                ]
              }
            },
            "response": []
          }
        ]
      }
    EOS

    assert_match /newman/, shell_output("#{bin}/newman run #{path}")
    assert_equal version.to_s, shell_output("#{bin}/newman --version").strip
  end
end
