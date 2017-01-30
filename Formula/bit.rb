require "language/node"
class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "http://104.154.76.155:8081/artifactory/bit-brew/stable/bit/0.1.7/bit-0.1.7-brew.tar.gz"
  sha256 "4957423b77965bade8a28c0215d33f51d9b8362121b22e1d1e1663c98546fe88"

  bottle do
    sha256 "d76c4e27029635bbd2916c82e64a96c2ae6d38d1c7f1069df3f8e2aa0213c53e" => :sierra
    sha256 "8e52ab1476db819b99c3b5ccfb2b327679be1976f72ffb96bcd9a18fedc8e013" => :el_capitan
    sha256 "93cb779cd8656613695284bd6e03b25cb7051115f8b055b8012f51e5ecb4be01" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", "-g", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "successfully initialized an empty bit scope.\n",
      shell_output("#{bin}/bit init")
  end
end
