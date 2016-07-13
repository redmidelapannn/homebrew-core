require "language/go"

class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.15.0",
      :revision => "6dc5d0f9c4cbc62828c91a923482c2341d36acb3"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "fb0e84700eb32655ce3ba61da858eb0171b241d6d0936ebe6f9dab7bb8aec64c" => :el_capitan
    sha256 "686923e0f31c7ca902475e43d0bf5aab24f318697c5c5ddebc2c83ad569491cb" => :yosemite
    sha256 "9c736586efab7ceaa7da5d4d8a78516a322919ec86309371ae7ea72568f95fe3" => :mavericks
  end

  devel do
    url "https://github.com/hashicorp/consul-template.git",
        :tag => "v0.16.0-rc1",
        :revision => "95065346ba9a95564536f2154dfb054c18cc5cc3"
    version "0.16.0-rc1"
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
    :revision => "6e9ee79eab7bb1b84155379b3f94ff9a87b344e4"
  end

  # gox dependency
  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
    :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/hashicorp/consul-template"
    dir.install buildpath.children

    Language::Go.stage_deps resources, buildpath/"src"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    cd("src/github.com/mitchellh/gox") { system "go", "install" }

    cd dir do
      system "make", "updatedeps" if build.head?
      system "make", "dev"
      system "make", "test"
    end

    bin.install "bin/consul-template"
  end

  test do
    (testpath/"template").write <<-EOS.undent
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end
