class Zenio < Formula
  desc "CLI Zenio Tool"
  homepage "https://dev.zenio.co"
  url "https://dev.zenio.co/cli/zenio-0.8.1.tar"
  sha256 "8838c70497d0d4e99365c32a7a197f90f2d3e67a8b1cab5e5a6ebac4f6d1bc92"

  bottle do
    cellar :any_skip_relocation
    sha256 "14119a89fe4e82ac6ba4fc36d0b12d671d701e9566e73793674e48b9d51ee0b1" => :mojave
    sha256 "14119a89fe4e82ac6ba4fc36d0b12d671d701e9566e73793674e48b9d51ee0b1" => :high_sierra
    sha256 "b78903195c00b44411e14426863d20d4e76e72d3faffe5508003744619e3770f" => :sierra
  end

  depends_on :java

  def install
    inreplace "zenio", "##PREFIX##", prefix
    inreplace "zenio", "##VERSION##", "#{version}-all"
    prefix.install "zenio-#{version}-all.jar"
    bin.install "zenio"
  end

  test do
    system "#{bin}/zenio", "init", "GitLab"
  end
end
