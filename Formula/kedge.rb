class Kedge < Formula
  desc "Simple, Concise & Declarative Kubernetes Applications"
  homepage "http://kedgeproject.org"
  url "https://github.com/kedgeproject/kedge/archive/v0.6.0.tar.gz"
  sha256 "8df6c9251c8ea447c67cda0eac89a145573d4295b11d76191b3da803189b20d0"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/kedgeproject").mkpath
    ln_s buildpath, buildpath/"src/github.com/kedgeproject/kedge"
    system "make", "bin"
    bin.install "kedge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kedge version")
    (testpath/"kedgefile.yml").write <<~EOS
      name: test
      containers:
      - image: test
    EOS
    assert_match "name: test", shell_output("#{bin}/kedge generate -f kedgefile.yml")
  end
end
