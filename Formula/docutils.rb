class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.16/docutils-0.16.tar.gz"
  sha256 "7d4e999cca74a52611773a42912088078363a30912e8822f7a3d38043b767573"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e5ee6a22e1227a58c6f661415e3a46206f5db1d631d7018833d7d976f0d59a5c" => :catalina
    sha256 "beb5c18f02c21c09ce19cba65a19cdb3a9401e8391466e16fd039c990b61a0bd" => :mojave
    sha256 "91f8db9ce4e4dcaab926cf1279fb7339c7760bb4389916674c5483c835bb8fad" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
