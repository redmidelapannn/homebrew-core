class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.3.0.tar.gz"
  sha256 "670eae9df5a2bbfbcb8e4b7da4f545188993b1f2a75b1ce26038941f80dbd514"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    rebuild 1
    sha256 "6531cc5976241f09a71e1a6acd7457338023f14b3edc0e461be8ed0b54f7eadf" => :sierra
    sha256 "a36cd5cb95de5d5da94842879102df21d8ccfb4cb62fab10a5c2b3d680cf2b4a" => :el_capitan
    sha256 "846591320e25e33ba49a5fe7f88b6f69c6e8ed5ac01488edce848c157b15a6b6" => :yosemite
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.4.0-beta.1.tar.gz"
    version "1.4.0-beta.1"
    sha256 "9c5bc4bacfa085ae652da9af1f290ceb52eedf36a8f903a4b7b2a680be48fe30"
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    if build.stable?
      assert_match version.to_s, shell_output("#{bin}/dub --version")
    else
      assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
    end
  end
end
