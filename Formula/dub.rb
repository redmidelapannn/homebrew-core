class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.9.0.tar.gz"
  sha256 "48f7387e93977d0ece686106c9725add2c4f5f36250da33eaa0dbb66900f9d57"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    rebuild 1
    sha256 "9e22106a1c61fe7dd51b5dd69ce1f808ff6f5e4e77304b155dd3bd55c2626ec8" => :high_sierra
    sha256 "c38bf2a396cfb73934577bfd697f259a8b906dc17aed145f52f72728cbd62a4e" => :sierra
    sha256 "fa030ba5181cc883742c5600fbc04970385c38c704df5dd374cc0e8b4244659a" => :el_capitan
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.10.0-rc.1.tar.gz"
    sha256 "672f3027ac51381fa26146554cc7cbb5103271a4239a43e35b4ad7ef8ab70345"
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
