class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.2.0.tar.gz"
  sha256 "2c39570b8f5f69283ac2889b6de532680f7164ad326cd028410a8152b75b3389"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "b5d49affffd7cb075db55db0c1776899774fa49a75bab42358f74b03c3a08464" => :el_capitan
    sha256 "e7dc0e25690eb1c96da1055a619fdbfe0cc1be730d2b8ed03508d2267afda32f" => :yosemite
    sha256 "e73425d150a11d181c434f9f814cd344826fd6bd9f5cc9de027f028f9c3fcc81" => :mavericks
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
