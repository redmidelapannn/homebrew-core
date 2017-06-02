require "language/node"

class AzureCliAT10 < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.12-May2017.tar.gz"
  version "1.0.10.13"
  sha256 "60194e770b8dca0485db9d4c99f9cd432f7b43096cc5ad0353f52fd5b1b29181"
  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e1487caefa750c72b07ab03c5fc6cfb3b431c538bc14e4b6ae792028a28b33d" => :sierra
    sha256 "8ae184b6a9e6f43eeba1c5f55fb3d2b5b13416f8507b944e33705b48681ab443" => :el_capitan
    sha256 "8a66c55952d8228f7b432cfb54f36b24d1f7046726dabb03e3d95e8852604834" => :yosemite
  end

  depends_on "node"
  depends_on :python => :build

  def install
    rm_rf "bin/windows"

    # Workaround for incorrect file system permissios inside the npm published
    # easy_table@0.0.1 package, which would break build with npm@5.
    # See: https://github.com/Azure/azure-xplat-cli/issues/3605
    inreplace "package.json", '"easy-table": "0.0.1",',
              '"easy-table": "https://github.com/eldargab/easy-table/archive/v0.0.1.tar.gz",'

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bash_completion/"azure").write Utils.popen_read("#{bin}/azure --completion")
  end

  test do
    shell_output("#{bin}/azure telemetry --disable")
    json_text = shell_output("#{bin}/azure account env show AzureCloud --json")
    azure_cloud = JSON.parse(json_text)
    assert_equal azure_cloud["name"], "AzureCloud"
    assert_equal azure_cloud["managementEndpointUrl"], "https://management.core.windows.net"
    assert_equal azure_cloud["resourceManagerEndpointUrl"], "https://management.azure.com/"
  end
end
