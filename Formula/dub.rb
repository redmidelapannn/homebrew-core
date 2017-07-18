class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.3.0.tar.gz"
  sha256 "670eae9df5a2bbfbcb8e4b7da4f545188993b1f2a75b1ce26038941f80dbd514"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    rebuild 1
    sha256 "49fb169be77d5fa32a192d7ba2c33325444486ee676866908e1708ca3374c43f" => :sierra
    sha256 "e9edab39765753e68c38bc926724f45de1b4d11573295edfef5ae1dc72cee404" => :el_capitan
    sha256 "5ee5f9f0ffeb610931507cc7399464cb2f67c206a3bac5ec73f6e0d1ae1c8fdc" => :yosemite
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.4.0-rc.1.tar.gz"
    version "1.4.0-rc.1"
    sha256 "10c17a74540e2f1b6e1768155d2a741fa62bd454661e6828c80b367e6418462c"
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
