class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.19.0.tar.gz"
  sha256 "97b50addfc26b4edbcafedec2be79b095eab0abd7b277d0e6e1b6fa882d55351"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2ffec91a7194918ef18a4651384fbba3da93b9a10c8fcd7db53ff29c28cbfb0b" => :high_sierra
    sha256 "c057b941d2c9817235c2fe5108eefce17d18713c12cc852b19d6ca11e8f2fa4b" => :sierra
    sha256 "0e8ad1cc15239dd0b9faaf457a680568d2ec651ad196e01fbf0fefdd0010000c" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd "src/github.com/Workiva/frugal" do
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
