class IosCi < Formula
  desc "Build, Archive & Export iOS/MacOS app via command-line"
  homepage "https://tungdev1209.github.io/ios-ci/"
  url "https://github.com/tungdev1209/ios-ci/archive/v1.1.3.tar.gz"
  sha256 "cdd4696b707d035190ff306d0c5ea5467cf920873d8281531d03ebe4bd7ed897"

  bottle do
    cellar :any_skip_relocation
    sha256 "7210f6bc8e5f9c4e3551d23ab0702b286521e9c0a540c4a913c1622ef815904c" => :mojave
    sha256 "c7f45c277baf67e1f0ad964a71e63454f06b5f181f0650ac8c7538ba5d518b14" => :high_sierra
    sha256 "c4ada0d710a8b91d77e49a8420f93f4423990056fff726052ffa41ace4736c62" => :sierra
  end

  def install
    bin.install "ios-ci"
    prefix.install "Author"
    prefix.install "README.md"
    prefix.install "hooks"
    prefix.install "config"
    prefix.install "helper"
  end

  test do
    assert_match "ok", ` #{bin}/ios-ci __test_cmd `
  end
end
