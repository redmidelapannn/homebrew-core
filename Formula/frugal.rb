class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.17.0.tar.gz"
  sha256 "cb21d3aac4667b519a70c5f1f229888edcf420887688281c7803c51c1a21fca1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "eb23233335c095bb95abc5b911ee6adef78e212118c83fa5d284b5876d634e8c" => :high_sierra
    sha256 "57d32e963a48b92fc7298c136e35608d1e4d836313d30505386b4f6813e25916" => :sierra
    sha256 "f28d17858f879267478a387a5ff113b1634233f2d02db50cf106788e36905471" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd buildpath/"src/github.com/Workiva/frugal" do
      system "glide", "install"
      system "go", "build", "-o", bin/"frugal"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
