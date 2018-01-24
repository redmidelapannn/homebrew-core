class Kirimori < Formula
  desc "Tool for managing vim plugin"
  homepage "https://github.com/syossan27/kirimori"
  url "https://github.com/syossan27/kirimori/archive/v0.0.3.tar.gz"
  sha256 "5f9a0f1b30f888137201b4ba4558ba7e633855a53d53b6058f386521838aee0f"
  head "https://github.com/syossan27/kirimori.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a0015e1e8b40fd3c5473750137cf00e396b73e0b27bf1d0b8aa909ffa50795c" => :high_sierra
    sha256 "da1bb1ea339896500e57d746730446ebf7e09ccfd93431b0409a5466f0bc8e5c" => :sierra
    sha256 "f83a04976d92e02cce52c86dcedbf0398e5365defc5ac0e40827976f17d138b4" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/syossan27/kirimori").install buildpath.children
    cd "src/github.com/syossan27/kirimori" do
      system "dep", "ensure"
      system "go", "build", "-o", bin/"kirimori"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/kirimori", "--version"
  end
end
