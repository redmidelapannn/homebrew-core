require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-5.0.0.tgz"
  sha256 "07a87547269ac02e0599ee098d836094785e2583215d058c60d812a5ff3ea5b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "91a604f0a1622b92fb6978e96e1cc6e85d12c6b26c3124a7b296d616566e6b30" => :catalina
    sha256 "b0fccdfad2d2bf5881caf18e5aa7b316d2fda30fba870eccb5f21bde55a5c72b" => :mojave
    sha256 "232821411dfd3b1f2a348fff7ec0451dee5008c50d65b64bd54e18413c0d3c52" => :high_sierra
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
