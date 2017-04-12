class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers."
  homepage "https://github.com/wercker/stern"
  url "https://github.com/wercker/stern/archive/1.4.0.tar.gz"
  sha256 "32c65ad4710bb84ab187443f78d1016c9e76b18ef7396c841571bf2ce9907b2b"

  head "https://github.com/wercker/stern.git",
    :shallow => false

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6636163923b3e90b5175a87f0fc7ddc0529ef3cf4f3738f409b230dd9cc9ec47" => :sierra
    sha256 "743ffc65671b71450661d564257d5b484295ae171cae76a535a6e6bfcd5e8341" => :el_capitan
    sha256 "9733bea68d2d438436cee11bae7d251454d10d43979bfdf9fcd6fee6ed9f340e" => :yosemite
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/wercker/stern").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    cd gopath/"src/github.com/wercker/stern" do
      system "govendor", "sync"
      system "go", "build", "-o", "bin/stern"
      bin.install "bin/stern"
    end
  end

  test do
    system "#{bin}/stern", "--version"
  end
end
