require "language/node"

class GenerateJsonSchema < Formula
  desc "Generate a JSON Schema from Sample JSON"
  homepage "https://github.com/Nijikokun/generate-schema"
  url "https://github.com/nijikokun/generate-schema/archive/v2.2.1.tar.gz"
  sha256 "693c7c8cdb4dc9c1bbd13746ba61b7862eb41557202293ad8f5538f83ef6a237"
  head "https://github.com/Nijikokun/generate-schema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c6d12a4d3e602347e18020272da4cfc98eecb5addcd7cb9e59017db201e928f" => :el_capitan
    sha256 "4400cf626cab0c48dc1709b82535c29899822de52c3954ca6174d5d3eef66181" => :yosemite
    sha256 "e83be1ae5f5d394837d644c7706503627b21a99135bc146872060a7370c7ed40" => :mavericks
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    require "open3"

    input = <<-EOS.undent
      {
          "id": 2,
          "name": "An ice sculpture",
          "price": 12.50,
          "tags": ["cold", "ice"],
          "dimensions": {
              "length": 7.0,
              "width": 12.0,
              "height": 9.5
          },
          "warehouseLocation": {
              "latitude": -78.75,
              "longitude": 20.4
          }
      }
    EOS

    output = <<-EOS.undent.chomp
      Welcome to Generate Schema 2.1.1

        Mode: json

      * Example Usage:
        > {a:'b'}
        { a: { type: 'string' } }

      To quit type: exit

      > {
        "$schema": "http://json-schema.org/draft-04/schema#",
        "type": "object",
        "properties": {
          "id": {
            "type": "number"
          },
          "name": {
            "type": "string"
          },
          "price": {
            "type": "number"
          },
          "tags": {
            "type": "array",
            "items": {
              "type": "string"
            }
          },
          "dimensions": {
            "type": "object",
            "properties": {
              "length": {
                "type": "number"
              },
              "width": {
                "type": "number"
              },
              "height": {
                "type": "number"
              }
            }
          },
          "warehouseLocation": {
            "type": "object",
            "properties": {
              "latitude": {
                "type": "number"
              },
              "longitude": {
                "type": "number"
              }
            }
          }
        }
      }
      >
    EOS

    # As of v2.1.1, there is a bug when passing in a filename as an argument
    # The following commented out test will fail until this bug is fixed.
    # ("#{testpath}/test.json").write(input)
    # system "#{bin}/generate-schema", "#{testpath}/test.json"

    # Until it is fixed, STDIN can be used as a workaround
    Open3.popen3("#{bin}/generate-schema") do |stdin, stdout, _|
      stdin.write(input)
      stdin.close
      # Program leaks spaces at the end of lines. This line cleans them up
      # so they don't cause the assert below to erroneously fail.
      result = stdout.map(&:rstrip).join("\n")
      assert_equal output, result
    end
  end
end
