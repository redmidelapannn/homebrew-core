class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/kubernetes/helm.git",
      :tag => "v2.3.0",
      :revision => "d83c245fc324117885ed83afc90ac74afed271b4"
  head "https://github.com/kubernetes/helm.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a5d580e792785547c92ce40b8c624b94942a7b909a1a49e266f52782898d3b38" => :sierra
    sha256 "43a542c66661e050b0cb22307a4cc449bac2d624bc866ff20fa7d22bbf791c9b" => :el_capitan
    sha256 "89261aabbd8c05876120020e725224d87a0c87a51609cb814a7160527dd1bf34" => :yosemite
  end

  depends_on :hg => :build
  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    ENV["TARGETS"] = "darwin/#{arch}"
    dir = buildpath/"src/k8s.io/helm"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # Bootstap build
      system "make", "bootstrap"

      # Make binary
      system "make", "build"
      bin.install "bin/helm"

      # Install bash completion
      bash_completion.install "scripts/completions.bash" => "helm"
    end
  end

  test do
    system "#{bin}/helm", "create", "foo"
    assert File.directory? "#{testpath}/foo/charts"

    version_output = shell_output("#{bin}/helm version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
  end
end
