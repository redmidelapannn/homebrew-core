class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/2.0.1.tar.gz"
  sha256 "5ef118f6d75fe84b5c24b2f9250edbbe4a5c14f1a70a978eabd80e4f91047497"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dd234910dd6d9337121d7b365e361506921f84937c7696318c18e8db4c5c9109" => :high_sierra
    sha256 "2d8f872dc2ccde2536f7fdb68efe879202f61153b994b00ef36c34eed52cebd5" => :sierra
    sha256 "2834ca0cf4fe190cf54018f84ab4f4e2e7921a71fe885d2bb098f43030665f62" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  conflicts_with "python-yq", :because => "both install `yq` executables"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/mikefarah/yq").install buildpath.children

    cd "src/github.com/mikefarah/yq" do
      system "govendor", "sync"
      system "go", "build", "-o", bin/"yq"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq n key cat").chomp
    assert_equal "cat", pipe_output("#{bin}/yq r - key", "key: cat", 0).chomp
  end
end
