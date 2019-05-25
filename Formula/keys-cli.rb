require "language/node"

class KeysCli < Formula
  desc "Command-line client for the keys environment manager"
  homepage "https://keys.cm"
  url "https://registry.npmjs.org/keys-cli/-/keys-cli-2.2.4.tgz"
  sha256 "2679ce9d45636be1b6c321effac4060f02d8ebd92c63cbe6391e3016e00d90fc"

  bottle do
    sha256 "83df0c5a359cc795ded7f5a7fb516e27d12b4bf74f9444935d6e0cdab00dea25" => :mojave
    sha256 "0b1501efa9daa9b3f1eabebd7c86d80aa2d10142a155cc9ca3ddb0f8d9952c9c" => :high_sierra
    sha256 "b5794fdbd8374a6b7af2d51f47665625126a3577bc4c3ddafae8ede8869160e1" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/keys", "--reset"
  end
end
