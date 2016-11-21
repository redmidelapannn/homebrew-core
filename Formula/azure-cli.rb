require "language/node"

class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.10.7-November2016.tar.gz"
  version "0.10.7"
  sha256 "4015616bd3a95ec319db4e3e098bf7251120123528d34d1dcc985834057cf531"
  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "31d4420d8070659496d119b05b9aa14ad592c31d0957776cf8487acb3e62005c" => :sierra
    sha256 "9b1cf8da7bf535d0e93ef47f200e3dea2edbdacb8be019f19b400793b3eac9cd" => :el_capitan
    sha256 "763d6dd650c209aaad910233437cf81a6782df22965edce95f3ae780ea6401a9" => :yosemite
  end

  depends_on "node"
  depends_on :python => :build

  def install
    rm_rf "bin/windows"
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
