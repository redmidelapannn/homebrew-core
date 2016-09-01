class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.4.2.tar.gz"
  sha256 "66dd72033653e41f26a2e9524ccc04650ebccb9af42daa00b106fc9e1436ddef"
  head "https://github.com/peco/peco.git"

  bottle do
    rebuild 1
    sha256 "5489958e39dc9eac74d0091ee3731707abe045388f49c1c38ae47f4845092420" => :el_capitan
    sha256 "60a4357fe78e701bbf21dc8795641b266ca5f53625a0e1dcce38145494f0902f" => :yosemite
    sha256 "128e803f23d31ed5351dfde3d6297a70f40e9a9e916922e83a535dc18cdaa19f" => :mavericks
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/peco/peco").install buildpath.children
    cd "src/github.com/peco/peco" do
      # default $GLIDE_HOME doesn't work
      Dir.mktmpdir do |tmpdir|
        ENV["GLIDE_HOME"] = tmpdir

        system "glide", "install"
        system "go", "build", "-o", bin/"peco", "cmd/peco/peco.go"
        prefix.install_metafiles
      end
    end
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
