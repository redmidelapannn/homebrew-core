class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.8.1.tar.gz"
  sha256 "79ad2dca0679f6d8b6a4d75e7ccea7930957134743bba290c949d5aa1aa53a14"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    rebuild 1
    sha256 "eef06fb77d5885ef6a80f436c90db5fc73400e3bb4d1da8e7e9eb48baaded007" => :high_sierra
    sha256 "fc2e17e559f28441438baae1118db78ec48720d947b4edf6d84c8ff3cff2679e" => :sierra
    sha256 "a27117ae280b5917adc2ab6245ccbeddd31691126f68121075a6bc29d45e11e3" => :el_capitan
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.9.0-beta.1.tar.gz"
    sha256 "505729f13eb14845d0faf4665ae69f93430c49c03f4d67541a32052b98794c71"
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
