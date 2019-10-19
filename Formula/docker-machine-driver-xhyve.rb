class DockerMachineDriverXhyve < Formula
  desc "Docker Machine driver for xhyve"
  homepage "https://github.com/machine-drivers/docker-machine-driver-xhyve"
  url "https://github.com/machine-drivers/docker-machine-driver-xhyve.git",
      :tag      => "v0.4.0",
      :revision => "829c0968dac18547636f3ad6aa5ef83677f48267"
  head "https://github.com/machine-drivers/docker-machine-driver-xhyve.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "73c4a4083b2ff3dbdc49ad621c2d1e30ce139d39acd21b37f1e3be4bbc05ff59" => :catalina
    sha256 "47687f2575102442c3bfcabd2c1b5208e3708216647bf942666c42e51536a409" => :mojave
    sha256 "7bd5cfb8236a056557dbbb28da1603a9e3b43e3c873075634c857565cc5c13e3" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "docker-machine"
  depends_on :macos => :yosemite

  def install
    (buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve").install Dir["{*,.git,.gitignore,.gitmodules}"]

    ENV["GOPATH"] = "#{buildpath}/gopath"
    build_root = buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve"
    build_tags = "lib9p"

    cd build_root do
      git_hash = `git rev-parse --short HEAD --quiet`.chomp
      git_hash = "HEAD-#{git_hash}" if build.head?

      go_ldflags = "-w -s -X 'github.com/zchee/docker-machine-driver-xhyve/xhyve.GitCommit=Homebrew#{git_hash}'"
      ENV["GO_LDFLAGS"] = go_ldflags
      ENV["GO_BUILD_TAGS"] = build_tags

      system "make", "build", "CC=#{ENV.cc}"

      bin.install "bin/docker-machine-driver-xhyve"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    This driver requires superuser privileges to access the hypervisor. To
    enable, execute
        sudo chown root:wheel #{opt_prefix}/bin/docker-machine-driver-xhyve
        sudo chmod u+s #{opt_prefix}/bin/docker-machine-driver-xhyve
  EOS
  end

  test do
    assert_match "xhyve-memory-size",
    shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver xhyve -h")
  end
end
