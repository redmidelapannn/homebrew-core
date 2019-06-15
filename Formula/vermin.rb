class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://github.com/netromdk/vermin/archive/v0.6.0.tar.gz"
  sha256 "2271537cb54376481b852c852a35e9b09f6170f848dd8397f3c2dee4e0f07db8"

  head "https://github.com/netromdk/vermin.git", :branch => "master"

  bottle do
    cellar :any_skip_relocation
    sha256 "63a13559ea8f37f8f26f5b5be1d7d29919e58c638044637c51c9def2b8a44f9b" => :mojave
    sha256 "4c0f7ca2eb0fd11bfed34bb4df614758aedc81f3c0037b84d12015f1e2b6c7fe" => :high_sierra
    sha256 "09d2e2ba87d6146b510fb455df34605ff871790402345ebc71a7b9ee524a2768" => :sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    version = Language::Python.major_minor_version "python3"
    path = libexec/"lib/python#{version}/site-packages/vermin"
    assert_match "Minimum required versions: 2.7, 3.0", shell_output("#{bin}/vermin -q #{path}")
  end
end
