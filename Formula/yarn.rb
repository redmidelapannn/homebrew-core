require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  # Note: If updating this to a newer version, please change the URL to the official
  # yarnpkg.com download URL:
  # url "https://yarnpkg.com/downloads/0.15.0/yarn-v0.15.0.tar.gz"
  # This was not updated yet as Yarn 0.15.1 was an npm-specific release and is not available
  # as a standalone tarball.
  url "https://registry.npmjs.org/yarn/-/yarn-0.15.1.tgz"
  sha256 "f99fd587e84987909d5f9e918b8fe524349fdc548e5bc5c380c8f8c0a70c6b87"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "27e4314d45dd01eb93e70116d4f851d878a034d5f7d176aee137364bb7a023db" => :sierra
    sha256 "1d8d81d6bf8600c41d391a816c73a7692c4904268b7e23ac8378ab48ee8a4122" => :el_capitan
    sha256 "0f0863207fd5f477fd01d827ba33b20412f9e2fa602a12d70577f71f09451d84" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end
