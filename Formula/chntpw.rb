class Chntpw < Formula
  desc "The Offline NT Password Editor"
  homepage "https://github.com/Tody-Guo/chntpw"
  url "https://github.com/sidneys/chntpw/archive/0.99.6.tar.gz"
  sha256 "e915f5addc2673317285c6f022c94da7fdee415d9800cd38540a13706706786b"
  head "https://github.com/sidneys/chntpw.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "26df7f7cb620531be04a76eb8d60dfdb20a5109c25899a2e63952e4547b89dcf" => :mojave
    sha256 "c478dfd506e695a44ae6dfb2fd1ea90821674bb5e043e0c5615c0dd7bd6a1cd4" => :high_sierra
    sha256 "1424ac6d7339aac3d37c0d525002ab76b4dd435392916c4305b6eb3905d1bc89" => :sierra
  end

  depends_on "openssl"

  def install
    system "make"
    bin.install "chntpw"
  end

  test do
    assert_match "chntpw version 0.99.6 080526 (sixtyfour)", shell_output("#{bin}/chntpw -h")
  end
end
