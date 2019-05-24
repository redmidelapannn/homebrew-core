class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.8.0.tar.gz"
  sha256 "5b53152f0eda41f4e5c2b9727e262dea35fb7da46fc0e0eb732956675f0bed8b"
  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5465740ce8c98eebd9bfcf41d2367a2a0a512ad702df7325a16dd9f5329beddb" => :mojave
    sha256 "cc99e857458819e27138a59ccd18079646152ee1970a0b2c537602375873ab6e" => :high_sierra
    sha256 "6af96204a8e6b3211b617f28a9c129f6ad254c1e5ead24429fbeb3d56e51eaa5" => :sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    dir = "src/github.com/runatlantis/atlantis"
    build_dir = buildpath/dir
    build_dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", "atlantis"
      bin.install "atlantis"
    end
  end

  test do
    system bin/"atlantis", "version"
    port = 4141
    loglevel = "info"
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-whitelist INVALID"
    command = bin/"atlantis server --atlantis-url http://invalid/ --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http://localhost:#{port}/' 2>&1`
    assert_match %r{HTTP\/1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end
