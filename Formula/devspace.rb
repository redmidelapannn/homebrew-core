class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v3.5.14",
    :revision => "fc564ded13194a5394a4fb04c38d91dedd7fab25"

  bottle do
    cellar :any_skip_relocation
    sha256 "c55caf83aa7d8eed28c7ee95de89473485d38c9ea46ab35e974c91fddf5b2dc7" => :mojave
    sha256 "d4e6d74d821846802ebfe76e59c58f8bf0c2073cf1215566593ee78434e05751" => :high_sierra
    sha256 "e8cc3a3b67810ad13e2dc14873f5824f5ff2ee033101b9d4591f7e91198eabef" => :sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

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
