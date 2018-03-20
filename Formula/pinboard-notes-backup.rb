require "language/haskell"

class PinboardNotesBackup < Formula
  include Language::Haskell::Cabal

  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.3.tar.gz"
  sha256 "bc3ab1a8a3d92fcbda86dd8b4756b035be89e1e5b50bdd61f998b67c89243ae3"
  head "https://github.com/bdesham/pinboard-notes-backup.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e75ab48fab38af3011c27c1a8128f2f298d8740f69b525d3277709f80c94d1b1" => :high_sierra
    sha256 "4af72e59bc59dd0253d3e4e1b381d05e760a99517d1e7ae3500b8b5a36f5a0c1" => :sierra
    sha256 "8256723147674d72f6eb26ea2ad4951cfd017a11c6483b8bc88bcd532a892630" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build

  def install
    install_cabal_package
  end

  # A real test would require hard-coding someone's Pinboard API key here
  test do
    assert_match "TOKEN", shell_output("#{bin}/pnbackup Notes.sqlite 2>&1", 1)
    output = shell_output("#{bin}/pnbackup -t token Notes.sqlite 2>&1", 1)
    assert_match "statusCode = 500", output
  end
end
