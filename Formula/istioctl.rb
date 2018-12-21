class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.0.5",
      :revision => "c1707e45e71c75d74bf3a5dec8c7086f32f32fad"
  
  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b3cf50b04299d5a5650c4d62c8889ce0b93bd5d3adabc3bac82d5fb3eff0b08c" => :mojave
    sha256 "309916fe275686e09b44b23196dcee420500069cd430262aa26f0fffed818c4e" => :high_sierra
    sha256 "055146027bb410f27b9aac00136731e91d6717a2939100b3d9ddb9362fc7170d" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    srcpath = buildpath/"src/istio.io/istio"
    outpath = buildpath/"out/darwin_amd64/release"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "istioctl"
      prefix.install_metafiles
      bin.install outpath/"istioctl"
    end
  end

  test do
    # system "make", "istioctl-test"
    assert_match "Retrieve policies and rules", shell_output("#{bin}/istioctl get -h")
  end
end
