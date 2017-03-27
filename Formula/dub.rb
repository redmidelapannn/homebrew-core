class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.2.2.tar.gz"
  sha256 "6487b89afa5f2b57d6905cdb45b5e596eb18ed0081f311f6a260324b460f610a"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    rebuild 1
    sha256 "be1cbd8552571fad84addef940183defb3da76656626b46671946a46fc29a2ee" => :sierra
    sha256 "be1cbd8552571fad84addef940183defb3da76656626b46671946a46fc29a2ee" => :el_capitan
    sha256 "5dc9ecd5e5a30c44f510b172cfeee79716801e6782bb25310c20620f0830bec5" => :yosemite
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.3.0-beta.1.tar.gz"
    sha256 "1ae1c699c3e3dd3112c86c3bc2d561591e72bb48db7e0b8f769eeeda0dbc9486"
    version "1.3.0-beta.1"
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
