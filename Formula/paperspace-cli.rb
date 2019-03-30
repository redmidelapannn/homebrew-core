require "language/node"

class PaperspaceCli < Formula
  desc "Paperspace CLI to manage Paperspace cloud compute resources"
  homepage "https://www.paperspace.com/api"
  url "https://github.com/Paperspace/paperspace-node/archive/0.1.13.tar.gz"
  sha256 "d94951ba05bcf8f5c093503904299c6ed705111ec79eedda85081b82ee77ed8f"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc10a2494ecde83a94c77c5be1534858984711737a3afebcc07f597d7da94022" => :mojave
    sha256 "46963e108f2eff386f3554dda7ec0fdab87c25447d641dffd019f7c5e8297d1b" => :high_sierra
    sha256 "8503382ec2667c1abd1f3341a87d142d8b455efd54749074b1cb399e9fed122c" => :sierra
  end

  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "install", "pkg", *Language::Node.local_npm_install_args
    # Use node10 because it's the latest node that pkg can work with.
    system "./node_modules/.bin/pkg", "-t", "node10", "."
    File.rename("paperspace-node", "paperspace")
    bin.install "paperspace"
  end

  test do
    system "#{bin}/paperspace", "--version"
    system "#{bin}/paperspace", "--help"
    # Unfortunately testing all other paperspace functionality requires user
    #   credentials. (i.e. paperspace login)
  end
end
