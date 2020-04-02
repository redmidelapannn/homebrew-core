class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.9.3",
    :revision => "42237ecda2c7ffd7c3cfce85af736694e080021b"

  bottle do
    cellar :any_skip_relocation
    sha256 "adecde84826ab9177e0edc7f1fb189760183da937d78ec990d2d96dea5a00bcb" => :catalina
    sha256 "3faa5f9a1dc512cbffde80f2855e22ffa00822ed883fbb8ec611a17d73c247c3" => :mojave
    sha256 "cbd6df60c07fded6db112482965de4ec45f7942b63eff146e5a28dec8f659efd" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", "-trimpath", "-o", bin/"devspace"
    prefix.install_metafiles
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
