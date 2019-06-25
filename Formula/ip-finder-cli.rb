class IpFinderCli < Formula
  desc "The official command command-line for IPFinder"
  homepage "https://ipfinder.io/"
  url "https://github.com/ipfinder-io/ip-finder-cli/releases/download/v1.0.2/ipfinder.phar"
  sha256 "9c99ff6d75293cd9fb0efb9bbd9e0e5c6212067c23e402e5133d5e4ad093cded"
  bottle do
    cellar :any_skip_relocation
    sha256 "0a5c7ec6cd37fb20698beb48036a600c24b8d0b79f43f5403dcf7b9fdd4e00e1" => :mojave
    sha256 "0a5c7ec6cd37fb20698beb48036a600c24b8d0b79f43f5403dcf7b9fdd4e00e1" => :high_sierra
    sha256 "e0a4243b7483afd0a3eb6a4d3e568e4f8e23a66e021283045458fa24529fce9c" => :sierra
  end

  def install
    bin.install "ipfinder.phar" => "ipfinder"
  end
  test do
    assert_match /IPFinder Command Line Interface 1.0.2 by ipfinder.io Teams/, shell_output("#{bin}/ipfinder --version")
  end
end
