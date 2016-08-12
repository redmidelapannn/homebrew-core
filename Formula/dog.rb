class Dog < Formula
  desc "Command-line application that executes tasks"
  homepage "https://github.com/dogtools/dog"
  url "https://github.com/dogtools/dog/releases/download/v0.1.0/dog-v0.1.0.tar.gz"
  sha256 "f584e9d074b5d08a3e2cd5707cfa8961cc3dfa27102a78cc287f86dd061cd2fe"

  bottle do
    cellar :any_skip_relocation
    sha256 "22e0066251bb18fafac3757d6026b39ac322e5c7a4a450d6e50f1de7a13ee6a3" => :el_capitan
    sha256 "0e6695388a600382173f9b555cf024d20420251c7078f23b604463d1d2cf0f72" => :yosemite
    sha256 "cb0e1f1b1433a41f4cc80e6151d987533f5aababb30166ae8bf9f4de176e09f4" => :mavericks
  end

  def install
    prefix.install "darwin_amd64/dog"
  end

  test do
    system "dog"
  end
end
