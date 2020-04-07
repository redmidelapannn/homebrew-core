class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v4.1.1.tar.gz"
  sha256 "dd50e5e68813990dcaba23564a0481f09550e3e80402ac0e4689685b7b8c46a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "195d41e8b5456ec49487fe704c90e3669e2ed6a9dd0bfaf15e6d6aa7771b6ae6" => :catalina
    sha256 "65f49b715cc5bffb10f523f50456bae5765e05d2c28a2210438a365e1cb10f38" => :mojave
    sha256 "bb3a6dcfe6964db39b1b5a6f93bab02807517f5b19b0597abec3f753e57d6909" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X github.com/zricethezav/gitleaks/version.Version=#{version}",
                 *std_go_args
  end

  test do
    assert_match "remote repository is empty",
      shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git", 2)
  end
end
