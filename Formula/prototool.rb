class Prototool < Formula
  desc "Your Swiss Army Knife for Protocol Buffers"
  homepage "https://github.com/uber/prototool"
  url "https://github.com/uber/prototool/archive/v1.8.0.tar.gz"
  sha256 "e700c38e086a743322d35d83cb3b7a481a72d8136db71625a423ba6494a56e58"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "70013d9e302de65803fe7645ac0f2eb3404be7f5a03ea12d351e40ba3d55a046" => :mojave
    sha256 "c5986af04c7bdebe8b7341a0b0573d81dfd9b37e4c2b3da5b3f21d20826ada4d" => :high_sierra
    sha256 "fa5ecc77510e39981b011e57416cc0c8380af3f40a09e3022c4f5dcfe7bd58e1" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/uber/prototool"
    dir.install buildpath.children
    cd dir do
      system "make", "brewgen"
      cd "brew" do
        bin.install "bin/prototool"
        bash_completion.install "etc/bash_completion.d/prototool"
        zsh_completion.install "etc/zsh/site-functions/_prototool"
        man1.install Dir["share/man/man1/*.1"]
        prefix.install_metafiles
      end
    end
  end

  test do
    system bin/"prototool", "config", "init"
    assert_predicate testpath/"prototool.yaml", :exist?
  end
end
