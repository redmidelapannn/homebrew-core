class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.8.1.tar.gz"
  sha256 "e7dcaa8f50a51f878ed9a6478cba0c7b42aa34d33a1c9a7e6964fe4193aa51ca"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b3cd13ec8e85430c5751b7b53867313bfa22b2f61399b1c7752fbc22aad33771" => :high_sierra
    sha256 "777b64fc17a83907513dfa263d1d6f563f4308aed76bace97f3fefa1232db325" => :sierra
    sha256 "fa26526270e0735576b80963a1d0b0bb7d4947a8990cec3f5935308edbf87dea" => :el_capitan
  end

  stable do
    depends_on "kubernetes-cli@1.8"
  end

  devel do
    url "https://github.com/kubernetes/kops/archive/1.9.0-beta.2.tar.gz"
    sha256 "b2b8eedfec837cb0f06f0106d2dd76c033cf593d750154b242328790369a0a42"
    depends_on "kubernetes-cli@1.9"
  end

  depends_on "go" => :build

  def install
    ENV["VERSION"] = version unless build.head?
    ENV["GOPATH"] = buildpath
    kopspath = buildpath/"src/k8s.io/kops"
    kopspath.install Dir["*"]
    system "make", "-C", kopspath
    bin.install("bin/kops")

    # Install bash completion
    output = Utils.popen_read("#{bin}/kops completion bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.popen_read("#{bin}/kops completion zsh")
    (zsh_completion/"_kops").write output
  end

  test do
    system "#{bin}/kops", "version"
  end
end
