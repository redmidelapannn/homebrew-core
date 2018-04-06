class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.8.0.tar.gz"
  sha256 "acffbdee967a20aba2c08d2a9de6a8b23b8fb5a703eece684781758db2831d50"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    rebuild 1
    sha256 "b0393890be7370407e6ff1def39f8f5f13d09239fc2f00b52548752ca1ad42a3" => :high_sierra
    sha256 "d0f310c812ede38b81482837545905bca2f19acd804d76d6ec83101b36cf37cf" => :sierra
    sha256 "033312a04e709d4a67946d6524cd2c8f50e9a64ba0cd61aa670f2341a3c345b1" => :el_capitan
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.8.1-beta.1.tar.gz"
    sha256 "ea5be7a58ee4b25b0766fd73406e5ba256c9d8ee9cfa94ee921187b58e80cebd"
  end

  depends_on "pkg-config" => :recommended
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
