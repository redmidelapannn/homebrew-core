class Tflint < Formula
  desc "Terraform linter"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint/archive/v0.3.1.tar.gz"
  sha256 "63b58673b7a8535138fdd03c5fc40115e87f229aa14ed25ad7bf922c80676d74"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d241e740a70a8cc0ab33b9992eb29d7d2f7783bd29efea2d547f201e897338e" => :sierra
    sha256 "7476c6c780ffd8410d1660e70eecd1fe67aa5e53fa89b64e94c6e3e005077d49" => :el_capitan
    sha256 "35da7817a5e9200cd3c6f934d88486d5f5dcefcce7a86f79d1ae7b26ccf816dc" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home"
    (buildpath/"src/github.com/wata727/tflint").install buildpath.children
    cd "src/github.com/wata727/tflint" do
      system "glide", "install"
      system "go", "build", "-o", "tflint"

      bin.install "tflint"
    end
  end

  test do
    system "#{bin}/tflint", "--version"
  end
end
