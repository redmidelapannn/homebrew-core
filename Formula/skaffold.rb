class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag => "v0.6.0",
      :revision => "ced2917e5df941849460d8809a04ce1df1317455"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c0ca6f99cd457601019ceceec79db069d4fcee66c977ebb34db5aae439a2558c" => :high_sierra
    sha256 "ef18f74708fcfa6cc2c78cca4975a5bc62242af503f00788d1f9daae7fc343d3" => :sierra
    sha256 "1b817de15ec2c56c325c0fe18c575faa89f494395a84579c579fc9891b70ab92" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/GoogleContainerTools/skaffold"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "make"
      bin.install "out/skaffold"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/skaffold version --output {{.GitTreeState}}")
    assert_match "clean", output
  end
end
