class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://github.com/andreafrancia/trash-cli/archive/0.17.1.14.tar.gz"
  sha256 "8fdd20e5e9c55ea4e24677e602a06a94a93f1155f9970c55b25dede5e037b974"
  head "https://github.com/andreafrancia/trash-cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4103f9a7b2a7b0164d61fe37928b1be45ae96184dce0f1f7f1e532f6781c55bd" => :high_sierra
    sha256 "0a10719406b6281929984c57ecfa7087b1f9d6e6fcd40cb2290f8aeb715b13eb" => :sierra
    sha256 "b9c269cf60f919dda15465697a042c60900f1896668a762a5820f8ab7822bb2d" => :el_capitan
  end

  depends_on "python@2"

  conflicts_with "trash", :because => "both install a `trash` binary"

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "testfile"
    assert_predicate testpath/"testfile", :exist?
    system bin/"trash-put", "testfile"
    refute_predicate testpath/"testfile", :exist?
  end
end
