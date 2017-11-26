class RsyncTimeBackup < Formula
  desc "Time Machine-style backup for the terminal, using rsync"
  homepage "https://github.com/laurent22/rsync-time-backup"
  url "https://github.com/laurent22/rsync-time-backup/archive/v1.1.5.tar.gz"
  sha256 "567f42ddf2c365273252f15580bb64aa3b3a8abb4a375269aea9cf0278510657"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f96152b1974570d4d4a2e876624e55bae972c832bc5d0b908294241a49c25dd" => :high_sierra
    sha256 "3f96152b1974570d4d4a2e876624e55bae972c832bc5d0b908294241a49c25dd" => :sierra
    sha256 "3f96152b1974570d4d4a2e876624e55bae972c832bc5d0b908294241a49c25dd" => :el_capitan
  end

  def install
    bin.install "rsync_tmbackup.sh"
  end

  test do
    assert_match "--times --recursive", shell_output("#{bin}/rsync_tmbackup.sh --rsync-get-flags")
  end
end
