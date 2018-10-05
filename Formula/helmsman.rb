class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman/archive/v1.6.2.tar.gz"
  sha256 "587ae86423df96fd5f5409f1af1a1ab763274d780c0b3f8651202caf840050dc"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b9b7c5a095cc52bad65526b0efec885994de99df9bd12313f5fe17a5bad4a9f" => :mojave
    sha256 "8207af9f47852124e8c8b9fc1de9ce8666f1db30f879e5b5ebc4aa3209cb1785" => :high_sierra
    sha256 "d5b446e3bd33ddb9f752144985471a5edd8327b494814ec88cc3234555fa4ec9" => :sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/Praqma/helmsman"
    path.install Dir["*"]

    cd path do
      system "make", "build"
      bin.install "helmsman"
      puts "Happy Helming!"
    end

    prefix.install_metafiles path
  end

  test do
    assert_match "kubectl", shell_output("#{bin}/helmsman -verbose 2>&1")
    assert_match "Helm:", shell_output("#{bin}/helmsman -verbose 2>&1")
  end
end
