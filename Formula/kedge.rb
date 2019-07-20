class Kedge < Formula
  desc "Deployment tool for Kubernetes artifacts"
  homepage "https://github.com/kedgeproject/kedge"
  url "https://github.com/kedgeproject/kedge/archive/v0.12.0.tar.gz"
  sha256 "3c01880ba9233fe5b0715527ba32f0c59b25b73284de8cfb49914666a158487b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "52740abc8e0a8222fadcc801c5df2640b8a59d245f2ef2e9d91b3cdcee42ed8a" => :mojave
    sha256 "c46bbadb0b432a6e381287c595348c8497015166738580f0c258eee8c9544509" => :high_sierra
    sha256 "eb3633240e2107b6db58a9a8a2c739cbbb89c6e5ee575706f5a6c4e4bfe31e6b" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/kedgeproject").mkpath
    ln_s buildpath, buildpath/"src/github.com/kedgeproject/kedge"
    system "make", "bin"
    bin.install "kedge"
  end

  test do
    (testpath/"kedgefile.yml").write <<~EOS
      name: test
      deployments:
      - containers:
        - image: test
    EOS
    output = shell_output("#{bin}/kedge generate -f kedgefile.yml")
    assert_match "name: test", output
  end
end
