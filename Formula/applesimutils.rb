class Applesimutils < Formula
  desc "Apple simulator utilities"
  homepage "https://github.com/wix/AppleSimulatorUtils"
  url "https://github.com/wix/AppleSimulatorUtils/archive/0.5.1.tar.gz"
  sha256 "2dd3f5800c991d49c84b65b07f21b6a34bdb0e056bad5820ab1d9381e2f7758c"
  head "https://github.com/wix/AppleSimulatorUtils.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f02fbb1f8659a62d92587de77631b63a3f3843626f19dba524663acbc8f62001" => :sierra
    sha256 "f8c657dc991c7027da713ebf59b3ccc397bd970b31d386b5e5e192d40e4a678b" => :el_capitan
  end

  depends_on :xcode => ["8.1", :build]

  def install
    system "./buildForBrew.sh", prefix
  end

  test do
    system "#{bin}/applesimutils", "--help"
  end
end
