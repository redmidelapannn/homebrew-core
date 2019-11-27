class CloudstateCli < Formula
  desc "Cloudstate CLI"
  homepage "https://github.com/sleipnir/cloudstate-cli"
  url "https://github.com/sleipnir/cloudstate-cli/releases/download/0.3.54/cloudstate-0.3.54-osx.tar.gz"
  sha256 "c46f8abc9383bd43405cf1ccb3f7956bd0098748e344b40e5caeaeeff8d9a9ab"

  bottle do
    cellar :any
    sha256 "d15bcbbe7707aabb89aa06f9f6c496705934df64f8bc280fe97316e5f872aae1" => :catalina
    sha256 "d15bcbbe7707aabb89aa06f9f6c496705934df64f8bc280fe97316e5f872aae1" => :mojave
    sha256 "d15bcbbe7707aabb89aa06f9f6c496705934df64f8bc280fe97316e5f872aae1" => :high_sierra
  end

  def install
    bin.install "release/cloudstate"
  end

  test do
    system "false"
  end
end
