class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v2.1.0.tar.gz"
  sha256 "b1934928fe31884ec7537b431c6c47a6f1bc744c1357308ff5ae11c624179c88"

  bottle do
    cellar :any_skip_relocation
    sha256 "c76972a0d08cf3c9238a53ace5a341c154c817cee72f0a47b2f408eb6140472b" => :mojave
    sha256 "576bf4245731af32a8f341d6c9a686de835bc4e0218ceffc942d11e006033af8" => :high_sierra
    sha256 "45c3906ae831b6019df1e2b3822ce11d8a9ff326f18fa09e89164e6b9d66312a" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"github.com/zricethezav/gitleaks"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"gitleaks"
      prefix.install_metafiles
    end
  end

  test do
    assert_includes shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git"), "0 leaks detected"
  end
end
