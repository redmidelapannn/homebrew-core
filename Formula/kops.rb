class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.8.1.tar.gz"
  sha256 "e7dcaa8f50a51f878ed9a6478cba0c7b42aa34d33a1c9a7e6964fe4193aa51ca"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2a7733e9d20b1c120742b1f684157b50b45142b7051c03fdc0672a3ac49bdbfa" => :high_sierra
    sha256 "ec6df04bbe6cf7ddb240bc5cab621aa57ac6ab8a8b3ad2140413eeee51f98232" => :sierra
    sha256 "9f848ef4f889acfa578de479959e1c25912168e31eaf618a357131b871669409" => :el_capitan
  end

  devel do
    url "https://github.com/kubernetes/kops/archive/1.9.0-beta.2.tar.gz"
    sha256 "b2b8eedfec837cb0f06f0106d2dd76c033cf593d750154b242328790369a0a42"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

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
