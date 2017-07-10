require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.6.1.tgz"
  sha256 "13e5d0624c8fcdf69ec6bf2c902d481159b4450261e7a314d0a5af6d06e06d16"

  bottle do
    cellar :any_skip_relocation
    sha256 "d55d939e9061ad7be7dd8e42a24dee6baf85e8ecb4dd07e3bf1271350527d2b9" => :sierra
    sha256 "a57b6837dbfa7b7131ae24da8bb09719a4caca2569f677b880d01a893ba52b33" => :el_capitan
    sha256 "41b78f2852a093ce08ae36e270abf4be5003392ed237af6b87492912c2d0acf8" => :yosemite
  end

  depends_on "node"
  depends_on "yarn"
  depends_on :java => "1.8+"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    expected = 'Execution complete'
    assert_equal expected, shell_output("#{bin}/jhipster info").split("\n").pop
  end
end
