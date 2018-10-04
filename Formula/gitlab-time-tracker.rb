require "language/node"

class GitlabTimeTracker < Formula
  desc "Command-line interface for GitLab's time tracking feature"
  homepage "https://github.com/kriskbx/gitlab-time-tracker"
  url "https://registry.npmjs.org/gitlab-time-tracker/-/gitlab-time-tracker-1.7.27.tgz"
  sha256 "a29b7be0069201688dab67280fa681a1698db80f1f2abab18af962bedf960871"

  bottle do
    cellar :any_skip_relocation
    sha256 "43d9f8a886daa613ac86c71417a339e8f714f04591ad8354f55168d7e731167d" => :mojave
    sha256 "7f4c5a4e8a1dfaaad3eb7a6dc329262699185b8f77d4f3f0bf07c08901a23f4a" => :high_sierra
    sha256 "33d0bc49737a965bb2c2cd349c096fce8b897fe84f4266937ce3bc89ee5c646a" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match '/.*Resolving "gitlab"....*\nError: Invalid access token!/', shell_output("#{bin}/gtt report gitlab")
  end
end
