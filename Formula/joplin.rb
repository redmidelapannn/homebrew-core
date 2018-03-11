require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.100.tgz"
  sha256 "29a0429bfd4ec5f2be42571330f0bb112ef2511a8931a063fe9af0b9b6c76562"

  bottle do
    rebuild 1
    sha256 "1bb7bcf3e78ccda40377e444e494d5d1f9b028c094ef0c5313eb6ba7792abc5c" => :high_sierra
    sha256 "1a6d6b1ba6bd8668046e62fe885cd55bc3d618eae2e839466826b0df48fe37f2" => :sierra
    sha256 "8f304b7e35f420ff59f216f8faccd7977c4688826e85ed283242efab5f42bfd3" => :el_capitan
  end

  depends_on "node"
  depends_on "python@2" => :build if MacOS.version <= :snow_leopard

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
