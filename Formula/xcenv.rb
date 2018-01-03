class Xcenv < Formula
  desc "Xcode version manager"
  homepage "http://xcenv.org"
  url "https://github.com/xcenv/xcenv/archive/v1.1.1.tar.gz"
  sha256 "9426dc1fa50fba7f31a2867c543751428768e0592e499fb7724da8dae45a32ec"
  head "https://github.com/xcenv/xcenv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a099775336d8717d7e5b10aa1660aa310e45bd234a376841b67ac160aec3ca2a" => :high_sierra
    sha256 "a099775336d8717d7e5b10aa1660aa310e45bd234a376841b67ac160aec3ca2a" => :sierra
    sha256 "a099775336d8717d7e5b10aa1660aa310e45bd234a376841b67ac160aec3ca2a" => :el_capitan
  end

  def install
    prefix.install ["bin", "libexec"]
  end

  test do
    shell_output("eval \"$(#{bin}/xcenv init -)\" && xcenv versions")
  end
end
