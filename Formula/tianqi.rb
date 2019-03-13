require "language/node"
class Tianqi < Formula
  desc "A weather tool in your command line."
  homepage "https://github.com/smallyard/tianqi"
  url "https://github.com/smallyard/tianqi/archive/v1.5.3.tar.gz"
  sha256 "888112d589026d2e448131b8f69ef725592d2f1c4148bbc0df806a608a3ce67f"

  bottle do
    cellar :any_skip_relocation
    sha256 "74a2399004cce85ef2a203b037387e3897530a3992d08313eb1034db5053416a" => :mojave
    sha256 "ebbb46cc22ceb5e678a400db76258d0fd1940990aacd0c20b6d1ad15a5955595" => :high_sierra
    sha256 "ff17b0b30772dcb118289fdf669cdde65331adaaf73bff78d549f6ace322bad3" => :sierra
  end

  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/tianqi"]
  end

  test do
    assert_match "天气", shell_output("#{bin}/tianqi")
  end
end
