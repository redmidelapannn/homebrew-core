class Eureka < Formula
  desc "CLI tool to input and store your ideas without leaving the terminal"
  homepage "https://github.com/simeg/eureka"
  url "https://github.com/simeg/eureka/archive/v1.0.0.tar.gz"
  sha256 "19da7540b7232d25f8d180d58f4356534f7694eee5172eddc0e5bcf900e380c8"

  bottle do
    sha256 "08dcc11ca79d4fc81caa66c187976f56f27116c04bcd57bf64c91801905e6b12" => :high_sierra
    sha256 "2977700ff518be316251d1f2d375c8142e024b3834b7a85d8f7a323695f9c7ed" => :sierra
    sha256 "1c34610e752c103bb9d52cd32076cf0e32ac77d324401ffbd35085325e822dfc" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/eureka"
  end

  test do
    system bin/"eureka", "--help"
  end
end
