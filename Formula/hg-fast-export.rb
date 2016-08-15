class HgFastExport < Formula
  desc "Mercurial to git converter using git-fast-import"
  homepage "https://packages.debian.org/source/sid/hg-fast-export"
  url "http://http.debian.net/debian/pool/main/h/hg-fast-export/hg-fast-export_20140308.orig.tar.gz"
  version "20140308"
  sha256 "340f0aa4ba0180164eee01b3ef14f709006399770819e64a1d84d761a3e5ebd3"

  head "git://repo.or.cz/fast-export.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fc2561935304c2097dbc97a31e60bbeef45ed34de3c55e47499f0017e1c7e32" => :el_capitan
    sha256 "1a539b86ba5d596c81433c423aac866eeb4c4eadbdd1dc5e067c4c441076b23d" => :yosemite
    sha256 "c56a75c38a878c6ab1cd18ce177a9b7f9b4fee42a866cca995e576e9a1fd347b" => :mavericks
  end

  def install
    bin.install "hg-fast-export.py", "hg-fast-export.sh",
                "hg-reset.py", "hg-reset.sh",
                "hg2git.py"
  end

  test do
    system bin/"hg-reset.sh", "-h"
  end
end
