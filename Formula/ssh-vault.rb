class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault.git",
      :tag => "0.12.3",
      :revision => "33b59a33979223c2a5e7e5b63f0bd01e50fc04ae"

  head "https://github.com/ssh-vault/ssh-vault.git"

  bottle do
    rebuild 1
    sha256 "734faa91c9d964ca7e8a7491e4ad70f84d454046287b737eb4bf0bfe5cf72518" => :high_sierra
    sha256 "f435604dfbbfcb317d320694c67d815dc58f0e8326713dad3d9e28f07edf81bb" => :sierra
    sha256 "939a6ede63874bca216361ddfa402377558f81ff1271db6021934daf7c271487" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go@1.9" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ssh-vault/ssh-vault").install buildpath.children
    cd "src/github.com/ssh-vault/ssh-vault" do
      system "dep", "ensure", "-vendor-only"
      ldflags = "-s -w -X main.version=#{version}"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/ssh-vault", "cmd/ssh-vault/main.go"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("echo hi | #{bin}/ssh-vault -u new create")
    fingerprint = output.split("\n").first.split(";").last
    cmd = "#{bin}/ssh-vault -k https://ssh-keys.online/#{fingerprint} view"
    output = pipe_output(cmd, output, 0)
    assert_equal "hi", output.chomp
  end
end
