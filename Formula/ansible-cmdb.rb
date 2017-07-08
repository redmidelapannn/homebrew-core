class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.22/ansible-cmdb-1.22.zip"
  sha256 "c012d46a0f782d7443c6b230194d5afde1e3f72915869a43b119304800c916fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfc5839c67965ac0bb330bf097d1e6e0fa3eb971a3c2161570307ea8844dafbf" => :sierra
    sha256 "fad244928b149a64ec254f7df8b1146c7d30e196a883eb8569475c730e4eea11" => :el_capitan
    sha256 "fad244928b149a64ec254f7df8b1146c7d30e196a883eb8569475c730e4eea11" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  def install
    bin.mkpath
    man1.mkpath
    inreplace "Makefile" do |s|
      s.gsub! "/usr/local/lib/${PROG}", prefix
      s.gsub! "/usr/local/bin", bin
      s.gsub! "/usr/local/share/man/man1", man1
    end
    system "make", "install"
  end

  test do
    system bin/"ansible-cmdb", "-dt", "html_fancy", "."
  end
end
