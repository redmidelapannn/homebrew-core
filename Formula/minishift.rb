require "language/go"

class Minishift < Formula
  desc "Runs a single-node OpenShift cluster inside a VM"
  homepage "https://minishift.io/"
  url "https://github.com/minishift/minishift/archive/v1.2.0.tar.gz"
  sha256 "93f172811b6d0af8987c4dcc72f091032a65d882bf1e1d9094f76595cd3e138f"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b5155110343d931497759e0fa7ac4bf6ec4f4cd5cb275243a7b769834f1ccde" => :sierra
    sha256 "f70767b9b049c8ab291276e9844acfca4a3bc5c2f73bab307bfeb773415f483b" => :el_capitan
    sha256 "c7ead35403dedbb5705a09f32b5bbd2c4633028710889711099d52ed9d9a1f13" => :yosemite
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    (buildpath/"src/github.com/minishift/minishift").install buildpath.children
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/jteeuwen/go-bindata/go-bindata" do
      system "go", "install"
    end

    cd "src/github.com/minishift/minishift" do
      system "make"
      prefix.install_metafiles
    end

    bin.install "bin/minishift"
  end

  test do
    assert_equal "-- Installing default add-ons ... OK\nminishift v#{version}\n", shell_output("#{bin}/minishift version")
    assert_equal "Does Not Exist\n", shell_output("#{bin}/minishift status")
  end
end
