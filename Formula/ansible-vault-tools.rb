class AnsibleVaultTools < Formula
  desc "Tools for working with ansible-vault"
  homepage "https://github.com/building5/ansible-vault-tools/"
  url "https://github.com/building5/ansible-vault-tools/archive/v2.0.1.tar.gz"
  sha256 "ccbb255c22e2ed8af6ce9c8c3f855a0c0a983ca01784bedce7fa9629e66d2d5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b31e61034935825e7111715ca6fb9310905ff5060aa231c8eb4707f5e708fde0" => :sierra
    sha256 "b31e61034935825e7111715ca6fb9310905ff5060aa231c8eb4707f5e708fde0" => :el_capitan
    sha256 "b31e61034935825e7111715ca6fb9310905ff5060aa231c8eb4707f5e708fde0" => :yosemite
  end

  depends_on "ansible"
  depends_on "gnupg"

  def install
    bin.mkpath
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "ansible-vault-merge", "--help"
  end
end
