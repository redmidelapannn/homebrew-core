class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.3.2.tar.gz"
  sha256 "fef550f89340ee02e40aead9285dbce361de8e8c2daa5702a9b4a5b32f236aec"

  bottle do
    cellar :any_skip_relocation
    sha256 "9db017051c440f3041a036055bc4db2c5d9eaa77f3460bfb514ba95ad4e56da6" => :catalina
    sha256 "3106118804040b358c52433ce821ab27f44c6dead52875c10dcd5eeb5c97d5ab" => :mojave
    sha256 "90e62aae29c7481ef82d9111d76b15b9a49abafc6ac5799710f67b2762a67406" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/vmware-tanzu/velero"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "go", "build", "-o", bin/"velero", "-installsuffix", "static",
                   "-ldflags",
                   "-X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}",
                   "./cmd/velero"

      # Install bash completion
      output = Utils.popen_read("#{bin}/velero completion bash")
      (bash_completion/"velero").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/velero completion zsh")
      (zsh_completion/"_velero").write output

      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end
