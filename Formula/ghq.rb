class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.12.7",
      :revision => "3a4306ec482248f6643a3b3dd6ae0d3ffe8d7a7e"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e549398ed173a947a793812cf7aaa7612b59b88e6771c8d032279b0775297195" => :catalina
    sha256 "f3b485b8cb3a6fe9f86b00fe3646fadce9c79a9328571756549909286177ad50" => :mojave
    sha256 "37a49e20f78fff4cc27d1c383868d9e69f24a9344d71a217909afa9928bd07b2" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ghq"
    zsh_completion.install "zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end
