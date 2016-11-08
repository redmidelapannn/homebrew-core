class Deis < Formula
  desc "Deploy and manage applications on your own servers"
  homepage "https://deis.io/"
  url "https://github.com/deis/deis/archive/v1.13.3.tar.gz"
  sha256 "a5b28a7b94e430c4dc3cf3f39459b7c99fc0b80569e14e3defa2194d046316fd"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "559196e6b6e105d0c89de5e96052fd90dced27072a7c16303b3b5eda5fc0bfc9" => :sierra
    sha256 "13c8e637f0b83f5374adac21c252432f91e95b3840c98b7c766c9c0f59fb280c" => :el_capitan
    sha256 "94247d80445171507e53d800929aacfeebab3956d493275adc6963dc688d5894" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/deis").mkpath
    ln_s buildpath, "src/github.com/deis/deis"
    system "godep", "restore"
    system "go", "build", "-o", bin/"deis", "client/deis.go"
  end

  test do
    system bin/"deis", "logout"
  end
end
