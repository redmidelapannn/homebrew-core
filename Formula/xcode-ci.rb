class XcodeCi < Formula
  desc "CI iOS/MacOS app via command-line"
  homepage "https://tungdev1209.github.io/xcode-ci/"
  url "https://github.com/tungdev1209/xcode-ci/archive/v1.1.6.tar.gz"
  sha256 "1a6d019568da8a9d368fdd0211cb2fbd22b19ef0528e8c70e07c9c65d6d678a9"

  bottle do
    cellar :any_skip_relocation
    sha256 "b059f0ed182cdc0a2a329b45e9098f7783ad415b128424ada1e6811253c6a8c0" => :mojave
    sha256 "b059f0ed182cdc0a2a329b45e9098f7783ad415b128424ada1e6811253c6a8c0" => :high_sierra
    sha256 "7e6f002e5df28ac6c29c778ce600542c573a5400a3c2e7e8b849963a5e95d3af" => :sierra
  end

  def install
    bin.install "xcode-ci"
    prefix.install "Author"
    prefix.install "README.md"
    prefix.install "hooks"
    prefix.install "config"
    prefix.install "helper"
  end

  test do
    assert_match "ok", ` #{bin}/xcode-ci __test_cmd `
  end
end
