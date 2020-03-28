require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-8.0.6.tgz"
  sha256 "24b24ee476ac470f9ba290e66213f1b739be1c5aa8e9f2ecb8cb62824a40e40d"

  bottle do
    cellar :any_skip_relocation
    sha256 "fabdcab6a27d10414c26603f9f611dbe0b386852af189245a0919a7e3b28d412" => :catalina
    sha256 "81c1dc663646f66adc58210e539a878844564f3afda81c07c25331f43d72a846" => :mojave
    sha256 "d52f7b916d5041bcd0cd09893cd93cdc99054c574c234b378355dbf93d2f5878" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"nativefier", "--version"
  end
end
