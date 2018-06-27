class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.9.0.tar.gz"
  sha256 "48f7387e93977d0ece686106c9725add2c4f5f36250da33eaa0dbb66900f9d57"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    rebuild 1
    sha256 "c12a955f2f7d4745f8e02f888feb4de2818436c6322952ccc15b79a07fb93116" => :high_sierra
    sha256 "83d95bed482888e5cf1e2ed14e20c0746eb301f23a853f3e639f2f77b25cf8c7" => :sierra
    sha256 "ed5e53390a2e06f62bc48e6c93f14efb352ac3f03c464e304611e00dd8121a69" => :el_capitan
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.10.0-beta.2.tar.gz"
    sha256 "919aef01d97939a3c9a46a540178ece6742c095ce4edd9dab0c8ec7a4aebb30b"
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
