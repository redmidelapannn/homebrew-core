class Docutils < Formula
  desc "Text processing system for reStructuredText"
  homepage "http://docutils.sourceforge.net"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.12/docutils-0.12.tar.gz"
  sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee05c025462c3a5cb0ffd524e8fa146c1b3918eb4f4c6fd1006ea4bf4ae5db96" => :el_capitan
    sha256 "a0cb7ec024d31a9f6f3bbcde7f07249e966bf9000008f7aee46a0978dcda9cb9" => :yosemite
    sha256 "c1ad86af646657c57f0bd910c33e74ae6e14bfcf87cf5e8be774c6f480356674" => :mavericks
  end

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
