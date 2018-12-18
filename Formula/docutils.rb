class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.14/docutils-0.14.tar.gz"
  sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "f8beb394bbf6a245a3c157ca5f1971baa9cdd0d5eb1f679dc30778358cd1de06" => :mojave
    sha256 "151cdc113d02ec4d235fce79b045a08d6f4cace35a6250a7d0fb7107d6db190a" => :high_sierra
    sha256 "87d74fde67467a6e6fa14454268d561dbf742c00099aa6a2efea7ee07e620eba" => :sierra
  end

  depends_on "python@2"

  option "without-lxml", "build without XML processing support"
  option "without-pillow", "build without Python Image Library support"
  option "without-pygments", "build without code syntax highlighting support"

  def install
    virtualenv_install_with_resources

    if build.with?("lxml")
      system libexec/"bin/pip", "install", "lxml"
    end

    if build.with?("pillow")
      system libexec/"bin/pip", "install", "Pillow"
    end

    if build.with?("pygments")
      system libexec/"bin/pip", "install", "Pygments"
    end
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
