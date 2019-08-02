class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.12.3.tar.gz"
  sha256 "c5f628af01c4a0f4cb8b48b4e5a68809edfe7085f93c0b7461f733013998d29a"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fe55b0ea8c52125ac071075f38fcbb7b0fb70e2788497e8ea7b642933a256fd" => :mojave
    sha256 "0be14a12e91613c8fe34a7b17a3f7c3ac3db83044be1dc0a4b14d3e91c6445fd" => :high_sierra
    sha256 "2d9aa306d33f724299939f60ac768e095fd9f36980be5e74464a164ec4e2dce3" => :sierra
  end

  depends_on "go" => :build

  def install
    (buildpath/"src/github.com/bitnami/kubecfg").install buildpath.children

    cd "src/github.com/bitnami/kubecfg" do
      system "make", "VERSION=v#{version}"
      bin.install "kubecfg"
      pkgshare.install Dir["examples/*"], "testdata/kubecfg_test.jsonnet"
      prefix.install_metafiles
    end

    output = Utils.popen_read("#{bin}/kubecfg completion --shell bash")
    (bash_completion/"kubecfg").write output
    output = Utils.popen_read("#{bin}/kubecfg completion --shell zsh")
    (zsh_completion/"_kubecfg").write output
  end

  test do
    system bin/"kubecfg", "show", pkgshare/"kubecfg_test.jsonnet"
  end
end
