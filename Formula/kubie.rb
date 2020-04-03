class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.7.1.tar.gz"
  sha256 "6e897e6b4877a5fbed8721bee2469c15c1a7846b966bbfae8d43e12e5c0ea0c1"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    bash_completion.install "./completion/kubie.bash"
  end

  test do
    kube_config = [
      "apiVersion: v1",
      "clusters:",
      "- cluster:",
      "    server: http://0.0.0.0/",
      "  name: kubie-test-cluster",
      "contexts:",
      "- context:",
      "    cluster: kubie-test-cluster",
      "    user: kubie-test-user",
      "    namespace: kubie-test-namespace",
      "  name: kubie-test",
      "current-context: baz",
      "kind: Config",
      "preferences: {}",
      "users:",
      "- user:",
      "  name: kubie-test-user",
    ].join("\n") + "\n"
    kube_config_dir = "#{ENV["HOME"]}/.kube"
    mkdir_p(kube_config_dir)
    File.write("#{kube_config_dir}/kubie-test.yaml", kube_config)

    assert_match "kubie #{version}", shell_output("#{bin}/kubie --version")

    assert_match "The connection to the server 0.0.0.0 was refused - did you specify the right host or port?",
      shell_output("#{bin}/kubie exec kubie-test kubie-test-namespace kubectl get pod 2>&1")
  end
end
