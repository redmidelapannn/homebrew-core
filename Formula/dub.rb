class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.18.0.tar.gz"
  sha256 "5ea118388217ad9afe7ccd6a486c0139c39a45e464de662fecfa142a408c1880"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe96ed564ff2166deef6f67a8803fa703d90718a174c302d15fac0c6b3d72362" => :catalina
    sha256 "d0f441f470a369b310a5b014f0e8e65ad95e21449d7d83f1c20f47a883dbdf2b" => :mojave
    sha256 "0377bd69e0299ac4823f4d2feff378966be33ed6ba510a0bb19c53be8f950bad" => :high_sierra
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
