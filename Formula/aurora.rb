require "language/go"

class Aurora < Formula
  desc "Beanstalk queue server console"
  homepage "https://xuri.me/aurora"
  url "https://github.com/Luxurioust/aurora/archive/1.4.tar.gz"
  sha256 "ab37905703d5265efbc9b588cbad9099e5863696d5a4f88f05f4107d5a2530e7"

  bottle do
    cellar :any_skip_relocation
    sha256 "8be9579b274dcb842bd5727383d1804fc6326479f7fa42cf165def027021003f" => :sierra
    sha256 "19ff7e4024118944c4f591e0b3a206c01e352968017604832ba5ee3d4aab1774" => :el_capitan
    sha256 "215538725ef5de47b8ccd6def623c2597bd0143e521aa768e775f3bd2bb190a3" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "99064174e013895bbd9b025c31100bd1d9b590ca"
  end

  go_resource "github.com/rakyll/statik" do
    url "https://github.com/rakyll/statik.git",
        :revision => "e383bbf6b2ec1a2fb8492dfd152d945fb88919b6"
  end

  go_resource "github.com/kr/beanstalk" do
    url "https://github.com/kr/beanstalk.git",
        :revision => "e99e1a384e4ace0401329ea37f702a2904990f91"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    mkdir_p "src/github.com/Luxurioust"
    ln_s buildpath, "src/github.com/Luxurioust/aurora"
    system "go", "build", "-o", bin/"aurora"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aurora -v")
  end
end
