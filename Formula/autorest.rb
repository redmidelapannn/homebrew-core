require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.0.5226.tgz"
  sha256 "0cf4ca1a666fab595e87cb911bb8ead30af4b33024d183be4373146cefb6c6d4"

  bottle do
    cellar :any_skip_relocation
    sha256 "a01ffb3b8fc23c7b417b1e4977645e581ccd70c17741a592b5d718c35000d796" => :mojave
    sha256 "43346358889712ca4642bd76b5c1b0888d7b56d539584c19f54310b92d9ebc35" => :high_sierra
    sha256 "1749c9da28799d3cbe92c84c93b0bdfae2ab5cacb0f8efaeeb0e57edd6eba958" => :sierra
  end

  depends_on "node"

  resource "petstore" do
    url "https://raw.githubusercontent.com/Azure/autorest/5c170a02c009d032e10aa9f5ab7841e637b3d53b/Samples/1b-code-generation-multilang/petstore.yaml"
    sha256 "e981f21115bc9deba47c74e5c533d92a94cf5dbe880c4304357650083283ce13"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    resource("petstore").stage do
      system (bin/"autorest"), "--input-file=petstore.yaml",
                               "--nodejs",
                               "--output-folder=petstore"
      assert_includes File.read("petstore/package.json"), "Microsoft Corporation"
    end
  end
end
