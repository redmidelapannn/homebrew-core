class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.5.1",
      :revision => "9d07e185b0dd50e6fb1418caa4b4d879788807e3"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "0b09fd4ce2a3f556f87c5c698f6375035814da0485ff1b0a6639089cd4e60833" => :catalina
    sha256 "0b09fd4ce2a3f556f87c5c698f6375035814da0485ff1b0a6639089cd4e60833" => :mojave
    sha256 "0b09fd4ce2a3f556f87c5c698f6375035814da0485ff1b0a6639089cd4e60833" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"

    srcpath = buildpath/"src/istio.io/istio"
    outpath = srcpath/"out/darwin_amd64"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "istioctl", "istioctl.completion"
      prefix.install_metafiles
      bin.install outpath/"istioctl"
      bash_completion.install outpath/"release/istioctl.bash"
      zsh_completion.install outpath/"release/_istioctl"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end
