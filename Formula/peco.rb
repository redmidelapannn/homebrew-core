require "language/go"

class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.3.6.tar.gz"
  sha256 "edc1ec186a0f439ae84071c9e00f68fec6f8fe49efc9b6bb10462e72f7286b23"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "8a815691e49c144c967cbe69d1443e27094815d918b72167d67f54eba4371962" => :el_capitan
    sha256 "f1853ce7ace5ad726a4eaa5023412e204aefa50201253ba5c27ea5fbed402636" => :yosemite
    sha256 "a296f6ef747514e96c094add880e02ea8343e9e87b46f2aaf8df455ce7b2597b" => :mavericks
  end

  head do
    url "https://github.com/peco/peco.git"

    go_resource "github.com/lestrrat/go-pdebug" do
      url "https://github.com/lestrrat/go-pdebug.git",
      :revision => "a45b04725d5819f9f30fb68085be53b90a1d55f1"
    end

    go_resource "github.com/pkg/errors" do
      url "https://github.com/pkg/errors.git",
      :revision => "01fa4104b9c248c8945d14d9f128454d5b28d595"
    end

    go_resource "golang.org/x/net" do
      url "https://go.googlesource.com/net.git",
      :revision => "ef2e00e88c5e0a3569f0bb9df697e9cbc6215fea"
    end
  end

  depends_on "go" => :build

  go_resource "github.com/google/btree" do
    url "https://github.com/google/btree.git",
    :revision => "00edb8c3163323f673bbe3c04afd9429eb12117d"
  end

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
    :revision => "6b9493b3cb60367edd942144879646604089e3f7"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
    :revision => "d6bea18f789704b5f83375793155289da36a3c7f"
  end

  go_resource "github.com/nsf/termbox-go" do
    url "https://github.com/nsf/termbox-go.git",
    :revision => "362329b0aa6447eadd52edd8d660ec1dff470295"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/peco"
    ln_s buildpath, buildpath/"src/github.com/peco/peco"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "cmd/peco/peco.go"
    bin.install "peco"
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
