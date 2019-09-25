class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.0.1",
    :revision => "cd8d7b64d31e309c1e3197438db85b47f9e37662"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "162af9a57896d0d45a492f86defdef37017186a76a9df8452a3b19af3c1cc5bd" => :mojave
    sha256 "994b5fd5af22a757f65775a4c1b4183df3a2bf8ae3af8005aadeff4ccdc6c5c1" => :high_sierra
    sha256 "c201e0278234f168b6efd06f7dfb3bb8f3ece863db412ada08a4a6736da00ae7" => :sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/devspace-cloud/devspace"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"devspace"
      prefix.install_metafiles
    end
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
