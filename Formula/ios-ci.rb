class IosCi < Formula
  desc "Build, Archive & Export iOS/MacOS app via command-line"
  homepage "https://tungdev1209.github.io/ios-ci/"
  url "https://github.com/tungdev1209/ios-ci/archive/v1.1.3.tar.gz"
  sha256 "cdd4696b707d035190ff306d0c5ea5467cf920873d8281531d03ebe4bd7ed897"

  bottle do
    cellar :any_skip_relocation
    sha256 "83977146ce0967fdd8263a711fe62b89a56a45ce1368112dbe44c1777cfd671d" => :mojave
    sha256 "83977146ce0967fdd8263a711fe62b89a56a45ce1368112dbe44c1777cfd671d" => :high_sierra
    sha256 "278f6265c3531dca7cd11c638fe7a306091fd50e2e653da230df7a4abb7e192d" => :sierra
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
