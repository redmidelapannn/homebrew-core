class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.15.0.tar.gz"
  sha256 "078f8fe5553be5910e5cf9169aefac8f83b1a029ae2d7e3fd31792bbf86820f3"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b9100de7cf8f328176285405bf3b56876fbf1ca6092da5a9e7831fd4c396f663" => :mojave
    sha256 "123f3e639e4abd0a0a09edc959e96dde0dc671ed9219ca66b808fea392efc654" => :high_sierra
    sha256 "49e3b6cd634b951600b0f33924a2e867015656db916976c78d5d4af7e94f727f" => :sierra
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
