require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v2.1.5.tar.gz"
  sha256 "e53689784d677e4f729dd723e753038b020e030522e7c43b5dd753b7079a05f7"

  bottle do
    sha256 "080500789f208ff381104c88ba85a1bfd152a2d7a11114475e243e25a05920a6" => :catalina
    sha256 "aa4b06388fc69c593b3b0e38c4757dceff4a78b9d90936b37c248b81deee91b6" => :mojave
    sha256 "7bad6ad7dc3858738ae59a13d830badcf3524a46fb3d892fc0b42239ed3d6dcf" => :high_sierra
  end

  depends_on "python" => :build
  depends_on "node@10"
  depends_on "unbound"

  def install
    system "#{Formula["node@10"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"hsd").write_env_script libexec/"bin/hsd", :PATH => "#{Formula["node@10"].opt_bin}:$PATH"
  end

  test do
    (testpath/"script.js").write <<~EOS
      const assert = require('assert');
      const hsd = require('#{libexec}/lib/node_modules/hsd');
      assert(hsd);

      const node = new hsd.FullNode({
        prefix: '#{testpath}/.hsd',
        memory: false
      });
      (async () => {
        await node.ensure();
      })();
    EOS
    system "#{Formula["node@10"].opt_bin}/node", testpath/"script.js"
    assert_true File.directory?("#{testpath}/.hsd")
  end
end
