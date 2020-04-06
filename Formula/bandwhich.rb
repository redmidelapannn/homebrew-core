class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.13.0.tar.gz"
  sha256 "42b0411c0a9df0b51fa5bedaa5f04fb001fdf46cd2d7ea9a58c98f4f6e7a15d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "2afaf25c6eb3d52e5dd03d6a8b8ac17bca391f504cd36a4c1ea025a2cfceba36" => :catalina
    sha256 "8decf42643152bd68a3c547b70606c492334cbb89105ca21f429f3c0fb53f7f2" => :mojave
    sha256 "2e7ea94c7a445bf44d142d3ee7bc7fbc29ad0be9223efff9fd9d8029b9dd110c" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 2
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
