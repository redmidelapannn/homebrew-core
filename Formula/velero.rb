class Velero < Formula
  desc "Backup and migrate Kubernetes applications and their persistent volumes"
  homepage "https://heptio.github.io/velero/"
  url "https://github.com/heptio/velero.git",
    :tag      => "v1.0.0-rc.1",
    :revision => "d05f8e53d8ecbdb939d5d3a3d24da7868619ec3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "855a28752c3c2044bcc9783f0787031be3fca540c2a25d1e5cd2a382176335d1" => :mojave
    sha256 "4599741a0ab6bd13819fab3531f22fb7f3e1e85e7e6ffc453441fdb25c0a33bc" => :high_sierra
    sha256 "544ce03f9979d88eb2414eec1dc9ec8b8bb71fdfef4a7a159a35e71cbb00d1a1" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/heptio/velero"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "go", "build", "-o", bin/"velero", "-installsuffix", "static",
                   "-ldflags",
                   "-X github.com/heptio/velero/pkg/buildinfo.Version=v#{version}",
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
