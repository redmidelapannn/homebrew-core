class HgGit < Formula
  desc "Git Mercurial Plugin"
  homepage "http://hg-git.github.io"
  url "https://bitbucket.org/durin42/hg-git/get/0.8.5.tar.bz2"
  sha256 "60bf47386fc0c9eef809344ff2be98eaa5add822f70dd25670470d06673fe2c4"
  head "https://bitbucket.org/durin42/hg-git", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "cbc59f10245783fca8e90a45ef2b648770cdcf7ac92d09896b8ec313827a4a29" => :el_capitan
    sha256 "c306e248f8718b930975fcbd6c6c317324f105cf39bf7f5723b667d3494ade0a" => :yosemite
    sha256 "f5d7b940a9b50da5ec4f766213995a76a27be42b06905762c74abaa4f479448e" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :hg

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    (testpath/".hgrc").write <<-EOS.undent
      [extensions]
      hggit=
    EOS
    system "hg", "clone", "git://github.com/schacon/hg-git.git"
  end
end
