class Rat < Formula
  desc "Compose shell commands to build terminal applications"
  homepage "https://github.com/ericfreese/rat/archive/v0.0.2.tar.gz"
  url "https://github.com/ericfreese/rat.git"
  version "0.0.2"
  sha256 "9da8d67a1e16056e3f05cdf536766e5571ede54a6c241c941d6c74eee5d64d31"

  bottle do
    cellar :any_skip_relocation
    sha256 "96f5f399718dd3bcf062ab825f9cdccf33d3d2f06f3ec88ba144d04b6a780452" => :high_sierra
    sha256 "496da445e4e5ca01b7049f86554920dd96b0c3b57a2846fb37c8fb9384b79b1b" => :sierra
    sha256 "c282724b0d1ad2bde75f61d6cdf0288d205446fc37440fadac502bbb34e39656" => :el_capitan
  end

  depends_on "go" => :build

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/ericfreese/rat").install contents

    ENV["GOPATH"] = gopath

    cd gopath/"src/github.com/ericfreese/rat" do
      system "go", "build", "-o", "rat"
      bin.install "rat"
      prefix.install_metafiles
    end
  end

  test do
    system "[", "-x", "#{bin}/rat", "]"
  end
end
