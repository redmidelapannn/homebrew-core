class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.18.0.tar.gz"
  sha256 "5ea118388217ad9afe7ccd6a486c0139c39a45e464de662fecfa142a408c1880"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9563e15c6ca988d12373cd6cbaa18fd7b8b6945dc26bbf466a81c4b5e56ef965" => :catalina
    sha256 "0fd6a0dc4390d50b8362668408966f8b160e8996dc887b435438a466a7b06c75" => :mojave
    sha256 "6b81ebf71fbc8a6b9793ccfe8cca408bdbf074aef3274c94baa077046da10cd7" => :high_sierra
  end

  depends_on "dmd" => :build
  depends_on "pkg-config"
  uses_from_macos "curl"

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
