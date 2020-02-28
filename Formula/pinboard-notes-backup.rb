require "language/haskell"

class PinboardNotesBackup < Formula
  include Language::Haskell::Cabal

  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.4.1.tar.gz"
  sha256 "c21d87f19bba59bb51ff7f7715a33a4a33ced20971f4881fd371ab3070a4b106"
  head "https://github.com/bdesham/pinboard-notes-backup.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7a68d655d9cd3e2e2afacc15c66d02faa53addde6805287500ae1daf3c2f5f65" => :catalina
    sha256 "3dcfe3d559b604457c2185841e7dc31a96d3bbe5805da21867b0a45d8cc81caa" => :mojave
    sha256 "c286ea429913922a96b3909e7a04467bbdd2022a2914c1411c3c3bb8a0d482ad" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  def install
    install_cabal_package
    man1.install "man/pnbackup.1"
  end

  # A real test would require hard-coding someone's Pinboard API key here
  test do
    assert_match "TOKEN", shell_output("#{bin}/pnbackup Notes.sqlite 2>&1", 1)
    output = shell_output("#{bin}/pnbackup -t token Notes.sqlite 2>&1", 1)
    assert_match "HTTP 500 response", output
  end
end
