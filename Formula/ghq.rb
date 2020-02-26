class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      :tag      => "v1.1.0",
      :revision => "057e0ffe6cc3ca0ea0ffdf3bdbb5f92e6fd780a4"
  head "https://github.com/x-motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ffe29fce973d1bff91fef3d09ac018ba57bb7977b8bd12e5826b68f1fd1bfbb4" => :catalina
    sha256 "d3340f822af41963b9efe3ec4c169e78776cc04926b2425b8dd039f61018189d" => :mojave
    sha256 "1f02737e638c2d3e5a8c19fc15b2a2522c7e29a719c99813e5d9e42a6d5c312e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
