require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.10.7.tgz"
  sha256 "d033b76974be7103933abe1fc937297d29c19aa1cdabbba8d5032ebd9d4f72f0"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "afe3d143711a5af30fd1ed82b42c7264d5bf5b54cfa7ac540ae86f5fe617809a" => :high_sierra
    sha256 "bff947e5bfffe8ce05b87cee0f7a8def87404ce0f21e927ab56fb5cfc58327ec" => :sierra
    sha256 "ad7c79f56cc40ec7996f5112db8009f549f5f05cf6966a5c141fcafd01dd626e" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "successfully initialized an empty bit scope.\n",
                 shell_output("#{bin}/bit init --skip-update")
  end
end
