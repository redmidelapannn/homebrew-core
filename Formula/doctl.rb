require "language/go"

class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.1.0.tar.gz"
  sha256 "c20d130ee3a64d8befbb816702a472469e063b60b75ee41384a66dfd2c97e409"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c8f1799cdd13e396f6f141351158ab35588cd4449267e3a0f84236eae8399d4" => :el_capitan
    sha256 "031cfdb2b4d562eba9f6123ee205d2a25c40d3cb82981a8ad5e3c6a750cea43d" => :yosemite
    sha256 "229352fae7e25a9c074ea20dd872c167787d3d61927ff64d8b69ceaa2e568993" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/digitalocean/"
    ln_sf buildpath, buildpath/"src/github.com/digitalocean/doctl"
    Language::Go.stage_deps resources, buildpath/"src"

    doctl_version = version.to_s.split(/\./)
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{doctl_version[1]}
      #{base_flag}.Minor=#{doctl_version[1]}
      #{base_flag}.Patch=#{doctl_version[0]}
      #{base_flag}.Label=release
    ].join(" ")
    system "go", "build", "-ldflags", ldflags, "github.com/digitalocean/doctl/cmd/doctl"
    bin.install "doctl"
  end

  test do
    assert_match "doctl version #{version.to_s}-release", shell_output("#{bin}/doctl version")
  end
end
