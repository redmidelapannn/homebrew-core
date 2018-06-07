class Ironcli < Formula
  desc "Go version of the Iron.io command-line tools"
  homepage "https://github.com/iron-io/ironcli"
  url "https://github.com/iron-io/ironcli/archive/0.1.6.tar.gz"
  sha256 "2b9e65c36e4f57ccb47449d55adc220d1c8d1c0ad7316b6afaf87c8d393caae6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ae334dcdfb366ee3dce2a0740a74039f2dc4b45f56f6065ce835bebf0779927a" => :high_sierra
    sha256 "d1f93964e214d81e6d053d830a04c69365c961b138163c78649bf90e7cb299d5" => :sierra
    sha256 "ebe1dbf7554ade6c738f34f6207728e348561ace41cc14f32851cb0056356c95" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/iron-io/ironcli").install buildpath.children
    cd "src/github.com/iron-io/ironcli" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"iron"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"iron", "-help"
  end
end
