class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.2.2.tar.gz"
  sha256 "6487b89afa5f2b57d6905cdb45b5e596eb18ed0081f311f6a260324b460f610a"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    rebuild 1
    sha256 "e44650ec49f5e7bb87842402f1c8114434c26698ae8f773f4fe4a020a523694d" => :sierra
    sha256 "e657dfde95f1b9add4f7d29c9418f25f6d5a705e09b43b0b554b614749faf93f" => :el_capitan
    sha256 "619bacf94a8ee2bd82cb60743b2a816a33f0eda2e8d56eebd65f2762284650a2" => :yosemite
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.3.0-beta.2.tar.gz"
    sha256 "cb889aa4f76454018a6f3baab746d36c6feb946f0be0199a698951fdab01d236"
    version "1.3.0-beta.2"
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version")
  end
end
