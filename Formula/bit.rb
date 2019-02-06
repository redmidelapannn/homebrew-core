require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.0.0.tgz"
  sha256 "9f2a186562d08d9987c6c9b83274dac84cae16168cb266479f1f99ad20947d9e"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "07e4b78315b0b73c6bdb1bb198ae9ad6313bd759442f51b62714c48a96bc657d" => :mojave
    sha256 "6e019ba6cfff97640dcb75bc634a8552752f145c4829d7e6bff88a1913cd4c56" => :high_sierra
    sha256 "78a7c852a81df240b019f2c912e5b9b72ef122d31036bcae845dc9af9bdd0972" => :sierra
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
