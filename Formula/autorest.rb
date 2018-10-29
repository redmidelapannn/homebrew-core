require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-2.0.4283.tgz"
  sha256 "a655719fa6dd20b11db4a3d9c5853e9ed0454429bd6371f0bc6a5a9014b1bb8d"

  bottle do
    sha256 "c412a0c9af2fa43c4809c41470a57f3bdbc796cba155fa1279385c9bd57073c8" => :mojave
    sha256 "1447f7b7d611914f6940dd9e170705ba4baa25b95badc4ffc4df7ce6d86e3eb4" => :high_sierra
    sha256 "8fcbd15d67152f51854983c9c537c4a159362577deee2677df912ad692d863a8" => :sierra
  end

  depends_on "mono"
  depends_on "node"

  resource "swagger" do
    url "https://raw.githubusercontent.com/Azure/autorest/764d308b3b75ba83cb716708f5cef98e63dde1f7/Samples/petstore/petstore.json"
    sha256 "8de4043eff83c71d49f80726154ca3935548bd974d915a6a9b6aa86da8b1c87c"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    resource("swagger").stage do
      system bin/"autorest", "--input-file=petstore.json"
    end
  end
end
