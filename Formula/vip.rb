class Vip < Formula
  desc "Program that provides for interactive editing in a pipeline"
  homepage "https://www.cs.duke.edu/~des/vip.html"
  url "https://www.cs.duke.edu/~des/scripts/vip"
  version "19971113"
  sha256 "171278e8bd43abdbd3a4c35addda27a0d3c74fc784dbe60e4783d317ac249d11"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d4d4e43e16a975074c70fa52e2aa6b693c8b89493e91d566aed78255130dad3a" => :catalina
    sha256 "d4d4e43e16a975074c70fa52e2aa6b693c8b89493e91d566aed78255130dad3a" => :mojave
    sha256 "d4d4e43e16a975074c70fa52e2aa6b693c8b89493e91d566aed78255130dad3a" => :high_sierra
  end

  resource "man" do
    url "https://www.cs.duke.edu/~des/scripts/vip.man"
    sha256 "37b2753f7c7b39c81f97b10ea3f8e2dd5ea92ea8d130144fa99ed54306565f6f"
  end

  # use awk and /var/tmp as temporary directory
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/vip/19971113.patch"
    sha256 "96879c8d778f21b21aa27eb138424a82ffa8e8192b8cf15b2c4a5794908ef790"
  end

  def install
    bin.install "vip"
    resource("man").stage do
      man1.install "vip.man" => "vip.1"
    end
  end
end
