class Gopass < Formula
  desc "The slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.justwatch.com/gopass"
  url "https://www.justwatch.com/gopass/releases/1.0.2/gopass-1.0.2.tar.gz"
  sha256 "a2c64329355f72527a1e269b3ad97cd2d37012ebf283210ef947c10657d8f650"
  head "https://github.com/justwatchcom/gopass.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c847a6bbb941fd2e7c1716f7b168c8250d2d01ed5b018c7ec9b2d9ba6e3ef53" => :sierra
    sha256 "3c298beb6335d31834a0a6deaba31b53e601dde35ba9731746268081d56a83c5" => :el_capitan
    sha256 "57331ec26464f8b796f27c5516345abcffe3d56cef9c3cfb8d7e9c56de603105" => :yosemite
  end

  depends_on "go" => :build
  depends_on :gpg => :run

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/justwatchcom/gopass").install buildpath.children

    cd "src/github.com/justwatchcom/gopass" do
      prefix.install_metafiles
      ENV["PREFIX"] = prefix
      system "make", "install"
    end

    output = Utils.popen_read("#{bin}/gopass completion bash")
    (bash_completion/"gopass-completion").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gopass version")
  end
end
