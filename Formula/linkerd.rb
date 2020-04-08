class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"

  url "https://github.com/linkerd/linkerd2.git",
    :tag      => "stable-2.7.0",
    :revision => "b9caae0cd9c28abe9542c77a2883ce1ef524e7b8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e7203fb07c95b8cf3d72b325a030ef22b64d04b71a0a2373a2fdd7c00bfaf1fb" => :catalina
    sha256 "e06744649929755d74f4ea15a267eb3e8f6a8a68b3c1c7e9780113d0b66af13c" => :mojave
    sha256 "49c8550e07cb1d09538567b5499072da5d6a4cdcf657647bf7215e5db66caeb2" => :high_sierra
  end

  depends_on "go@1.13" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CI_FORCE_CLEAN"] = "1"

    srcpath = buildpath/"src/github.com/linkerd/linkerd2"
    srcpath.install buildpath.children - [buildpath/".brew_home"]

    cd srcpath do
      system "bin/build-cli-bin"
      bin.install "target/cli/darwin/linkerd"

      # Install bash completion
      output = Utils.popen_read("#{bin}/linkerd completion bash")
      (bash_completion/"linkerd").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/linkerd completion zsh")
      (zsh_completion/"linkerd").write output

      prefix.install_metafiles
    end
  end

  test do
    run_output = shell_output("#{bin}/linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    version_output = shell_output("#{bin}/linkerd version --client 2>&1")
    assert_match "Client version: ", version_output
    stable_resource = stable.instance_variable_get(:@resource)
    assert_match stable_resource.instance_variable_get(:@specs)[:tag], version_output if build.stable?

    system "#{bin}/linkerd", "install", "--ignore-cluster"
  end
end
