require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.9.0.tgz"
  sha256 "47a324fc0c9d91e0661182182f6b33947d9c9f3f445c8b18893f114b10a83bef"

  bottle do
    cellar :any_skip_relocation
    sha256 "56cab5c7e48923d4e7e63a3dcfecde8af4f331da04144c80d1d22600c818cb86" => :catalina
    sha256 "477fe6896ae35a8a41dd54b5454fb4c1c086560ee35b7e8839088e237cfc3498" => :mojave
    sha256 "8f8dfd812ed197c368325b3119a7451b7848d68e9d3bbd0549dedda0ccbd9dea" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
