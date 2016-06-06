class Rclone < Formula
  desc "Sync files to and from Google Drive, Amazon Cloud Drive, etc."
  homepage "http://rclone.org"
  url "https://github.com/ncw/rclone/releases/download/v1.29/rclone-v1.29-osx-amd64.zip"
  version "1.29"
  sha256 "64c95564ae69f5238000c6adb2f4d178923176ecfd9d64cddfd80bfa538e1c15"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a8e23ef7359a002034abc0261b9b8a176972ecca98738122ae0a7dd4c7e0a38" => :el_capitan
    sha256 "dc17622e25ede8ceb8d44f6979e18aa1a56149e2f748b918810ff8d314f9bd78" => :yosemite
    sha256 "c7ee81068a1f78190d15824186ce67ad204c4bdd3c0a93af6be20cf2dcdba783" => :mavericks
  end

  def install
    bin.install "rclone"
    man1.install Dir["*.1"]
  end

  test do
    system "#{bin}/rclone", "--help"
  end
end
