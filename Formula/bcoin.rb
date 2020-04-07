require "language/node"

class Bcoin < Formula
  desc "Javascript bitcoin library for node.js and browsers"
  homepage "https://bcoin.io"
  url "https://github.com/bcoin-org/bcoin/archive/v2.0.0.tar.gz"
  sha256 "ff99b735d3b23624455d72eada0de7f7ba4207f4a4cc0cab963ca2036de254a3"
  bottle do
    sha256 "1ddf0d2b1dc1821478b4e34fb13b62eca62611eea7fbe8ce022dbb6c4a8cdd14" => :catalina
    sha256 "99ebb4efe574968f1e6a15b650dff7f6a1d04bf04764d54f4b8715c20cfe39e9" => :mojave
    sha256 "3b4367711e145b5749e6492d629f3fc5790c2d24c7905f00b7047772bccded8b" => :high_sierra
  end

  depends_on "python@3.8" => :build
  depends_on "node"

  def install
    system "#{Formula["node"].libexec}/bin/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"bcoin").write_env_script libexec/"bin/bcoin", :PATH => "#{Formula["node"].opt_bin}:$PATH"
  end

  test do
    (testpath/"script.js").write <<~EOS
      const assert = require('assert');
      const bcoin = require('#{libexec}/lib/node_modules/bcoin');
      assert(bcoin);

      const node = new bcoin.FullNode({
        prefix: '#{testpath}/.bcoin',
        memory: false
      });
      (async () => {
        await node.ensure();
      })();
    EOS
    system "#{Formula["node"].bin}/node", testpath/"script.js"
    assert_true File.directory?("#{testpath}/.bcoin")
  end
end
