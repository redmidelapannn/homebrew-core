require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.1.0.tgz"
  sha256 "c35886b708e03f85dccd505d4c974c47b4958f49358a086dc038cf21695d50bc"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4b8bc3c27f19bf57530bf12fab2ed3ed8e7caceca0641b1b8c8b18800454f40e" => :high_sierra
    sha256 "1e8b2dd5676e1708a0959ed1f1aa20830d979146762a69ab6b71e476e9a8da70" => :sierra
    sha256 "963633dea51322e309d02b17d687296728fd3e598048940195238520227e489f" => :el_capitan
  end

  depends_on "node"
  depends_on "yarn"
  depends_on :java => "1.8+"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
