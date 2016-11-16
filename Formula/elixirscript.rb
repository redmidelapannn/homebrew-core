require "language/node"

class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/archive/v0.23.0.tar.gz"
  sha256 "d955cff7e0ea873821ecc007b4d44b8eb3fb51c51fa0cb8d782204cceecec6a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "2014c33f77fed19efa8689e0b19bfec58081cd2d8b50ebb0fd120f49665cf4f3" => :sierra
    sha256 "9165e52f28018b2fe1784191bf115b544d8afdc552d9a270ae7be45f5f6b54b0" => :el_capitan
    sha256 "e981f9f338cf08f14a64099acc5c27cfa1a7aed0b09cb7a6cee2314b5d31085e" => :yosemite
  end

  depends_on "elixir" => :build
  depends_on "node" => :build

  def install
    ENV["MIX_ENV"] = "prod"

    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "deps.get"
    system "npm", "install", *Language::Node.local_npm_install_args
    system "mix", "std_lib"
    system "mix", "clean"
    system "mix", "compile"
    system "mix", "dist"
    system "mix", "test"
    system "npm", "test"

    ENV.delete("MIX_ENV")
    system "mix", "docs"

    bin.install "elixirscript"
    prefix.install Dir["priv/*"]
    doc.install Dir["doc/*"]
  end

  test do
    output = shell_output("#{bin}/elixirscript -ex :keith")
    assert_equal "Symbol.for('keith')", output.strip
  end
end
