class TmuxXpanes < Formula
  desc "Ultimate terminal divider powered by tmux"
  homepage "https://github.com/greymd/tmux-xpanes"
  url "https://github.com/greymd/tmux-xpanes/archive/v2.2.3.tar.gz"
  sha256 "4357b8ac76f3d0b93dbb1626e0881f03143910f428a78db3d8437950bbd15fef"

  bottle do
    cellar :any_skip_relocation
    sha256 "42bc0df01a375c03fa045092852df22b4bb2212b67fcb0528b348d2bcfeb5894" => :high_sierra
    sha256 "42bc0df01a375c03fa045092852df22b4bb2212b67fcb0528b348d2bcfeb5894" => :sierra
    sha256 "42bc0df01a375c03fa045092852df22b4bb2212b67fcb0528b348d2bcfeb5894" => :el_capitan
  end

  depends_on "tmux" => :recommended

  def install
    system "./install.sh", prefix
  end

  test do
    # Check options with valid combination
    pipe_output("#{bin}/xpanes --dry-run -c echo", "hello", 0)

    # Check options with invalid combination (-n requires number)
    pipe_output("#{bin}/xpanes --dry-run -n foo -c echo 2>&1", "hello", 4)
  end
end
