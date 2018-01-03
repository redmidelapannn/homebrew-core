require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "http://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-0.10.85.tgz"
  sha256 "0c7fcca6897b20d1e396c221d444120a823a6c24dd85da574825d77240e33f87"

  bottle do
    sha256 "7769c328714687e91d1ff514cc615fa4c9610db1053e5b984df3423a2c4c84da" => :high_sierra
    sha256 "18b0a494d0583c4ec1429e8297503647eb9d1156954f2987d8cb8753d033f4e2" => :sierra
    sha256 "db29703086a078555d5b6fd3809f6509d975d4c65e30154e8d436a83b8da6621" => :el_capitan
  end

  depends_on "node"
  depends_on "python" => :build if MacOS.version <= :snow_leopard

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
