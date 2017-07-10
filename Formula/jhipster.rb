require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.6.1.tgz"
  sha256 "13e5d0624c8fcdf69ec6bf2c902d481159b4450261e7a314d0a5af6d06e06d16"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c3630de99401e3e39f954c5984cf1c823fbe008dda32d79f8e28ef82a23b413" => :sierra
    sha256 "5776876b59925a6e98efff2b7d3ab7203e329faf6fea5841866a4e64c14cdba2" => :el_capitan
    sha256 "9c62fcf4b3fc5710a3138283ccc928f0467f3b0a799e72d43c2c593b26548859" => :yosemite
  end

  depends_on "node"
  depends_on "yarn"
  depends_on :java => "1.8+"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    expected = <<-EOS.undent
      Executing jhipster:info
      Execution complete
    EOS
    assert_equal expected, shell_output("#{bin}/jhipster info")
  end
end
