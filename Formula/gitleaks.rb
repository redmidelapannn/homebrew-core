class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v2.1.0.tar.gz"
  sha256 "b1934928fe31884ec7537b431c6c47a6f1bc744c1357308ff5ae11c624179c88"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "645e2fbfec47545039714e3230803555f6a8502be1268129928e97dec9ebb227" => :mojave
    sha256 "154beb98c621cb4b9db93aa8f5ecc386c1c7b7b2198db42b4bf7dc92cdebaebc" => :high_sierra
    sha256 "c05ae673194b99f6210c4d9fd3648ad93b89927ad0f0f74e702dc16f23a39f17" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"github.com/zricethezav/gitleaks"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"gitleaks"
      prefix.install_metafiles
    end
  end

  test do
    assert_includes shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git", 2), "remote repository is empty"
  end
end
