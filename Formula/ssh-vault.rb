class SshVault < Formula
  desc "encrypt/decrypt using ssh keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault.git",
      :tag => "0.9.1",
      :revision => "ef5a4dfb4d2857b9586a27e96621a3bec576449a"

  head "https://github.com/ssh-vault/ssh-vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5db642c565a00642ff13ad73aa86619832f0fa4c8aa695722416b9978d71ca77" => :sierra
    sha256 "ed257add4e563c123c09229da34bbee24a29103402c69d3c5d7f43e89cce855d" => :el_capitan
    sha256 "32567f2970616c0a23b4954766afc341d679eae3218dac3b247c6136a4c7f667" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ssh-vault/ssh-vault").install buildpath.children
    cd "src/github.com/ssh-vault/ssh-vault" do
      system "make"
      bin.install "ssh-vault"
    end
  end

  test do
    system bin/"ssh-vault", "-v"
  end
end
