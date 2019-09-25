class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/weaveworks/flux"
  url "https://github.com/weaveworks/flux.git",
      :tag      => "1.14.2",
      :revision => "7fd090af0dd9b63acc9fa1c8616d5bf5657c6160"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fb2e0ff3277a6203a9b6c3a8311b29af898348fcf441ba15d0e72211a1e70bf5" => :mojave
    sha256 "d79a1037d95f6aa7e582663e3406e8e3afae69a24dd1dade51d252f67105b280" => :high_sierra
    sha256 "c81ce61b14ab86f37036e0c0089df7bfd72b84028a676d8da5e9581b689146ae" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/weaveworks/flux"
    dir.install buildpath.children

    cd dir/"cmd/fluxctl" do
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"fluxctl"
      prefix.install_metafiles
    end
  end

  test do
    run_output = shell_output("#{bin}/fluxctl 2>&1")
    assert_match "fluxctl helps you deploy your code.", run_output

    version_output = shell_output("#{bin}/fluxctl version 2>&1")
    assert_match version.to_s, version_output

    # As we can't bring up a Kubernetes cluster in this test, we simply
    # run "fluxctl sync" and check that it 1) errors out, and 2) complains
    # about a missing .kube/config file.
    require "pty"
    require "timeout"
    r, _w, pid = PTY.spawn("#{bin}/fluxctl sync", :err=>:out)
    begin
      Timeout.timeout(5) do
        assert_match r.gets.chomp, "Error: Could not load kubernetes configuration file: invalid configuration: no configuration has been provided"
        Process.wait pid
        assert_equal 1, $CHILD_STATUS.exitstatus
      end
    rescue Timeout::Error
      puts "process not finished in time, killing it"
      Process.kill("TERM", pid)
    end
  end
end
