class RmateBash < Formula
  desc "Remote TextMate 2 implemented as shell script"
  homepage "https://github.com/aurora/rmate"
  url "https://github.com/aurora/rmate.git",
      :revision => "ace81cf9402ce3b9b96afa1ca9c633d84751be75"
  version "1.0.2"
  head "https://github.com/aurora/rmate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd3ede1209dd03ad4f214c8875367678361be93b668f560d14b560f51da16377" => :mojave
    sha256 "bd3ede1209dd03ad4f214c8875367678361be93b668f560d14b560f51da16377" => :high_sierra
    sha256 "f5ccbc0ed32ccce84186ec596dea4ed8610f7ab3ae40277c5aa98643d3fd51d6" => :sierra
  end

  conflicts_with "rmate", :because => "both install `rmate` scripts"

  def install
    bin.install "rmate"
  end

  test do
    system "#{bin}/rmate", "--version"
  end
end
