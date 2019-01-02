class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://github.com/netromdk/vermin/archive/v0.4.10.tar.gz"
  sha256 "2b653a9440257867144bdec24ffa3493ac45c8f8ea4dabe4e5441991817b1f77"
  head "https://github.com/netromdk/vermin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f74784c8efec336cc128f684f6887eeef2c8d5c771ee82f5866e479cb5521831" => :mojave
    sha256 "41637d89faa6da666bff03a343a2bb249e1f0eee1c9f1a7b79e8b4b426db83ab" => :high_sierra
    sha256 "f6bce07c18385cadacef80b98e19f95fc3332dc6fc5361e6402b8384f44ee0b1" => :sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    path = Pathname.glob(libexec/"lib/python?.?/site-packages/vermin")[0]
    assert_match "Minimum required versions: 2.7, 3.0", shell_output("#{bin}/vermin -q #{path}")
  end
end
