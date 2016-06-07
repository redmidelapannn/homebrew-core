require "language/go"

class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.2.0.tar.gz"
  sha256 "2c39570b8f5f69283ac2889b6de532680f7164ad326cd028410a8152b75b3389"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8bfa98fa42e09ed58f730bb2c09373eb8ef0ff35bf8cee143e4e5376fe57889b" => :el_capitan
    sha256 "91f3a5b6958b22344eab9ca2bbb4c376a418b4e68221425bd8e69aea6c6800fb" => :yosemite
    sha256 "b640a5d66e4c88113efa96924c27dfed10fb83f46eaeaca76bd10dde7131ef04" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/digitalocean/"
    ln_sf buildpath, buildpath/"src/github.com/digitalocean/doctl"

    doctl_version = version.to_s.split(/\./)
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{doctl_version[0]}
      #{base_flag}.Minor=#{doctl_version[1]}
      #{base_flag}.Patch=#{doctl_version[2]}
      #{base_flag}.Label=release
    ].join(" ")
    system "go", "build", "-ldflags", ldflags, "github.com/digitalocean/doctl/cmd/doctl"
    bin.install "doctl"
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
