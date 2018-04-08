class GitRemoteHg < Formula
  include Language::Python::Virtualenv

  desc "Transparent bidirectional bridge between Git and Mercurial"
  homepage "https://github.com/felipec/git-remote-hg"
  url "https://github.com/felipec/git-remote-hg/archive/v0.3.tar.gz"
  sha256 "2dc889b641d72f5a73c4c7d5df3b8ea788e75a7ce80f5884a7a8d2e099287dce"
  head "https://github.com/felipec/git-remote-hg.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "3287f8c0065de58b3b758d247c98747d00d29f5c16d6743a19aa9450cf48c89c" => :high_sierra
    sha256 "dd304e5b230dc1104b0ffcb897a80c937e950f1bd50d9262c46bf1807c7d464f" => :sierra
    sha256 "4b7464728ee5f7b2137a86620ba3ac2bcc1f7858b8336a57f40e2aa0b977e366" => :el_capitan
  end

  depends_on "mercurial"
  depends_on "python@2"

  conflicts_with "git-cinnabar", :because => "both install `git-remote-hg` binaries"

  resource "hg" do
    url "https://mercurial-scm.org/release/mercurial-4.1.3.tar.gz"
    sha256 "103d2ae187d5c94110c0e86ccc3b46f55fcd8e21c78d1c209bac7b59a73e86d8"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install resource("hg")
    inreplace "git-remote-hg", /#!.*/, "#!#{libexec}/bin/python"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
  end
end
