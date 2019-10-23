class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.1.3",
    :revision => "50ecc7b0c701839468bec0ce5dcaf5670ca2b614"

  bottle do
    cellar :any_skip_relocation
    sha256 "511f7ef14880110cff380f8478f5f1ec2fc9643e11ab4514aa3ff187c044dca2" => :catalina
    sha256 "a028872ebc8941f354577f94ceca93c0cf411ab1d2615df8c4eec8eb2d436dce" => :mojave
    sha256 "1746f37543cd7dcd33a5a79d3c9a52eeaaace150992801d367fce0165fc8f9b7" => :high_sierra
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
