require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.2.4.tgz"
  sha256 "29f80b4a7ec4dd7ce52a62133ee40431c34648b90cf9821b68692a69b488de6a"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "86cdedbecc6fb79720b0af993b1dde2330ab24b9d9996fa404966bcadfc1ba1b" => :mojave
    sha256 "310c7b0af32271ce22de8a3b7fef54bb952ae733f1424c19b803de9529be4201" => :high_sierra
    sha256 "c854951b881eba277c2d6696a61f16c3ed3b195c4ffca48851d1d32203bc5a18" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"Library/Caches/Bit/config/config.json").write <<~EOS
      { "analytics_reporting": false, "error_reporting": false }
    EOS
    output = shell_output("#{bin}/bit init --skip-update")
    assert_match "successfully initialized", output
  end
end
