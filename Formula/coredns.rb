class Coredns < Formula
  desc "Plugin-driven DNS and service discovery"
  homepage "https://coredns.io"
  url "https://github.com/coredns/coredns.git",
    :tag => "v1.3.1",
    :revision => "6b56a9c92130d50cee9bd92aaee500dbccff395f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a6e45cbbbca8d49140f0932b630752c1b7c829297dd50ed9d18bbd5a9b9b4f6" => :mojave
    sha256 "b45397c250dbdbbea33936ed1b1185dbaaad50cbd1adfe998441a000336ac25b" => :high_sierra
    sha256 "cc2418cd639ffd34987a5887dd8c82b3d7f633c6351125646f790d780662c621" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/coredns/coredns"
    dir.install buildpath.children

    cd dir do
      system "make", "godeps", "all"
      bin.install "coredns"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"coredns", "-dns.port=1053"
  end
end
