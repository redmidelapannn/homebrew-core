require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.106.tgz"
  sha256 "c1f1b19f0d078cd232bce5f62e8ec4f1a69bfcddf1cb90701c7cd7a4ecc59613"

  bottle do
    rebuild 1
    sha256 "a19cf86cf2243b13f711780910b72bd6bfad5770e4636375116db43634242335" => :high_sierra
    sha256 "85398611e77822aa4d549af7eec9cf3908fff1e3fecaa267a1ec1b561e780697" => :sierra
    sha256 "e95d41ae284a6c7da6fd3ab738bcffb72864c65b5c8d04362d1fe42d3953ccf4" => :el_capitan
  end

  depends_on "node"
  depends_on "python@2" => :build

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
