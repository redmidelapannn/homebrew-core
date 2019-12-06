class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.0.tar.gz"
  sha256 "849abeaf750750c2b865e2540630a799dce0dcaf84ff574ccad22c8f66577531"
  head "https://github.com/subfinder/subfinder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "21052868f7bc8de6a6f72192df0219620a0a17bdf373cee24978e9cfaabc30f1" => :catalina
    sha256 "80f56585846fd7bbf97fc09df7759c0e1bc42df4bfb48972e16f32db5c44342e" => :mojave
    sha256 "eac4078c127289e87848522d72639e5e13ad9269740138e63ef1149a30e90f9e" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/projectdiscovery/subfinder/"
    path.install buildpath.children

    cd path do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", "#{bin}/subfinder", "cmd/subfinder/main.go"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/subfinder", "-config", "output.txt"
    assert_predicate testpath/"output.txt", :exist
  end
end
