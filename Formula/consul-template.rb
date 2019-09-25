class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag      => "v0.22.0",
      :revision => "005b42eb2414a945dfe205dba58f64cc3546a7b5"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c8b56c1160285911d030ce79c7d96a2e5c4817aed1024d8fa39e575b3f04b5be" => :mojave
    sha256 "1934651b5e12e131cc7ae0830beee7ce1c101616e919aacc1259b1221b2aec6c" => :high_sierra
    sha256 "14edd549d507e0db3bc97f7a1f3100c1ac7543cc78ad87bc0f1f5721c0f354bd" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = "amd64"

    dir = buildpath/"src/github.com/hashicorp/consul-template"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      project = "github.com/hashicorp/consul-template"
      commit = Utils.popen_read("git rev-parse --short HEAD").chomp
      ldflags = ["-X #{project}/version.Name=consul-template",
                 "-X #{project}/version.GitCommit=#{commit}"]
      system "go", "build", "-o", bin/"consul-template", "-ldflags",
             ldflags.join(" ")
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"template").write <<~EOS
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end
