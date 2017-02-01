class ConductrCli < Formula
  desc "The Lightbend ConductR CLI"
  homepage "https://conductr.lightbend.com"
  url "https://bintray.com/lightbend/generic/download_file?file_path=conductr-cli-1.0.1-Mac_OS_X-x86_64.zip"
  version "1.0.1"
  sha256 "fff2d3caa7cbbefc3da4a158b34a46bf51338ae921985cd4fb35d46e3c8eccf2"

  bottle do
    cellar :any_skip_relocation
    sha256 "87da70f4fd0f7ee0c0f502f79c44fe47dbc8909a594916dc66f793866e3deddb" => :sierra
    sha256 "f2203d245b40742ac2be582fd4c225627fb1181eaf4292bd5f73ce46cf4b5433" => :el_capitan
    sha256 "87da70f4fd0f7ee0c0f502f79c44fe47dbc8909a594916dc66f793866e3deddb" => :yosemite
  end

  def install
    bin.install Dir["*"]
  end

  test do
  end
end
