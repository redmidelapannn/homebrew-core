class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.14/docutils-0.14.tar.gz"
  sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4213acfb467fcc0c8677a356f3c812936bdf43eb892206ea715474fe04cb3521" => :high_sierra
    sha256 "7d7dabf4360107019e49757ae48a662285cddcfe1f4846cb52d687718e29725c" => :sierra
    sha256 "35f832ceaec779a04fa8dd36891b857c1b80f4392ebc3f1bfb95fa91dde20e2b" => :el_capitan
  end

  depends_on "python@2"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
