class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.15.tar.gz"
  sha256 "6fe66b07772ca000879bda65cb9d112d2dbbc301d6afa4d4b46055d385f86e36"

  head "https://github.com/keybase/client.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "f7611bf9174163559b308164d71b05ab217a6859104a451d74f03a41282c4b05" => :el_capitan
    sha256 "4c1a183a8ce48cbe65f60ab3db52d84bd449794ff677a88accfa745f99720670" => :yosemite
    sha256 "24efcbd8d9aafc3f293815c6d79344b2dca40052bf6ff16c5af414a9dea242a2" => :mavericks
  end

  depends_on "go" => :build
  depends_on "gnupg"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    (buildpath/"src/github.com/keybase/client/").install "go"

    system "go", "build", "-a", "-tags", "production brew", "github.com/keybase/client/go/keybase"
    bin.install "keybase"
  end

  test do
    system "#{bin}/keybase", "-standalone", "id", "homebrew"
  end
end
