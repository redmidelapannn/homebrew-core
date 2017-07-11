class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.3.0.tar.gz"
  sha256 "670eae9df5a2bbfbcb8e4b7da4f545188993b1f2a75b1ce26038941f80dbd514"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    rebuild 1
    sha256 "ea4fd085b7f853b01348cb8d2f7ef7f87b61c2c687b68ae5b9c5e6899e989b79" => :sierra
    sha256 "546a9674f9c71ad75dc2b631b075ffc013774f0b1ea55826b939e1a1efcf840b" => :el_capitan
    sha256 "466300362ac0ab3a9b6dbbed8d0e0ec5baf64f46fd3177030c9563c06b192911" => :yosemite
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.4.0-beta.4.tar.gz"
    version "1.4.0-beta.4"
    sha256 "7ed4179de436d46a5849accd45fd79d3751e5798ac25bbc679a3d7abc1b805e7"
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
