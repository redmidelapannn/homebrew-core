class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.7.1.tar.gz"
  sha256 "6e897e6b4877a5fbed8721bee2469c15c1a7846b966bbfae8d43e12e5c0ea0c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "14a38a57bf5d15ec84563f0175f52f692f1c0196d38532e6582c7cab3a7c5576" => :catalina
    sha256 "e4f3ae5ed0bda5f61a5fbf0550a19d393eb1f74da7789d412fc707bd4a7898f4" => :mojave
    sha256 "10d0f798645a9ecfcd9da44c18cdb2ddc30b78585839ec46e44905924940c517" => :high_sierra
  end

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
