class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/community-edition"
  url "https://github.com/docker/docker-ce.git",
    :tag => "v17.06.2-ce",
    :revision => "cec0b72a9940e047e945a09e1febd781e88366d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "81d4fc0c576c82b4231b08b88569abc0e4f5e29e4a6174ebb30999b43aa16bba" => :sierra
    sha256 "0c7f9fb7aeb3b151e43ef5fda04537146c9eb4f26b92d069b6be26af61ef3afc" => :el_capitan
    sha256 "be7356bd09b9e1f33269046ce99c91159507cd54a630291a555dac5bd33ce2e7" => :yosemite
  end

  # edge releases
  devel do
    url "https://github.com/docker/docker-ce.git",
      :tag => "v17.07.0-ce",
      :revision => "87847530f7176a48348d196f7c23bbd058052af1"
  end

  option "with-experimental", "Enable experimental features"
  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  if build.with? "experimental"
    depends_on "libtool" => :run
    depends_on "yubico-piv-tool" => :recommended
  end

  def install
    ENV["DOCKER_EXPERIMENTAL"] = "1" if build.with? "experimental"
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/docker/cli"
    dir.install (buildpath/"components/cli").children
    cd dir do
      commit = Utils.popen_read("git rev-parse --short HEAD").chomp
      ldflags = ["-X github.com/docker/cli/cli.GitCommit=#{commit}",
                 "-X github.com/docker/cli/cli.Version=#{version}-ce"]
      system "go", "build", "-o", bin/"docker", "-ldflags", ldflags.join(" "),
             "github.com/docker/cli/cmd/docker"

      if build.with? "completions"
        bash_completion.install "contrib/completion/bash/docker"
        fish_completion.install "contrib/completion/fish/docker.fish"
        zsh_completion.install "contrib/completion/zsh/_docker"
      end
    end
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
