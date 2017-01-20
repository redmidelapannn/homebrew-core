class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git",
      :tag => "v1.13.0",
      :revision => "49bf474f9ed7ce7143a59d1964ff7b7fd9b52178"

  head "https://github.com/docker/docker.git"

  bottle do
    sha256 "b0e0c576447389f773bc933d46360ca62ef0e29587a21ba52b90e3033499365f" => :sierra
    sha256 "95a5ee88d69b4a06de2c34fe13f75a3250b0e023a22bc129b3e9a9a9e5947deb" => :el_capitan
    sha256 "46745895ff80d8327e44ee733d484b71900f365236a8369e3cc19b9c7c6fce5b" => :yosemite
  end

  option "with-experimental", "Enable experimental features"
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

    build_version = build.head? ? File.read("VERSION").chomp : version
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
