class DockerEdge < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://docs.docker.com/edge/"
  url "https://github.com/docker/docker.git",
      :tag => "v17.04.0-ce",
      :revision => "4845c567eb35d68f35b0b1713a09b0c8d47fe67e"
  head "https://github.com/docker/docker.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d59d2685257d9447ca0227e1b84bbf6e360b0612225971e0d0bb08c474987d17" => :sierra
    sha256 "7cd16210d366f2bf027cf145aa30bdd1114c2feb13425ff62651af82af4c51c8" => :el_capitan
    sha256 "a8d4b0c125f0f30b03b1c9eb4eabaa56c63cbc5d55d7ce26804a43429686e916" => :yosemite
  end

  option "without-experimental", "Disable experimental features"
  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  if build.with? "experimental"
    depends_on "libtool" => :run
    depends_on "yubico-piv-tool" => :recommended
  end

  def install
    ENV["AUTO_GOPATH"] = "1"
    ENV["DOCKER_EXPERIMENTAL"] = "1" if build.with? "experimental"

    system "hack/make.sh", "dynbinary-client"

    build_version = build.head? ? File.read("VERSION").chomp : "#{version}-ce"
    bin.install "bundles/#{build_version}/dynbinary-client/docker-#{build_version}" => "docker"

    if build.with? "completions"
      bash_completion.install "contrib/completion/bash/docker"
      fish_completion.install "contrib/completion/fish/docker.fish"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
