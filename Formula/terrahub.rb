require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.2.6.tgz"
  sha256 "9159648ba6ef16afc540aac162425b9b1b7419952dfb3dfee6647287445375d5"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a40df27796878b2af1692071a6f13993e61cf0476bda84e58871e03270a5583" => :mojave
    sha256 "d5bce6abfc7a742504067cfe23c19a23540512d32034b6864d16ea6e390fd1ff" => :high_sierra
    sha256 "0659baddca7a000f4a73f65f391e7be3e8477ad00771eeb1c83b88164b9b54ea" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".terrahub.yml").write <<~EOF
      project:
        name: terrahub-demo
        code: abcd1234
      vpc_component:
        name: vpc
        root: ./vpc
      subnet_component:
        name: subnet
        root: ./subnet
        dependsOn:
          - ./vpc
    EOF
    output = shell_output("#{bin}/terrahub graph")
    assert_match "Project: terrahub-demo", output
  end
end
