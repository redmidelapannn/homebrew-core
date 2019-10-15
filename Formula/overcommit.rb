class Overcommit < Formula
  desc "Utility to install, configure, and extend Git hooks"
  homepage "https://github.com/sds/overcommit"
  url "https://github.com/sds/overcommit/archive/v0.49.1.tar.gz"
  sha256 "6bf60311211efdd036abe14d62cd314226f99d6c0676810e79df555a72bc9ac3"

  bottle do
    cellar :any_skip_relocation
    sha256 "7dcd6327001be0deab82a388e84ce113a9438c5179c3dc59f6600bdb64892a04" => :catalina
    sha256 "b1417a090fb6aefff7aee1ba23b7b2f1f6edfb2f4a5161e1dce8c9643e424a79" => :mojave
    sha256 "0398100ec1de49a88e418c9cbbc51760f8a8365862a3a6f74b089001665ddd9f" => :high_sierra
  end

  depends_on "ruby"
  depends_on "git" => :test

  resource "childprocess" do
    url "https://rubygems.org/downloads/childprocess-1.0.1.gem"
    sha256 "7fe65b8d220967e8b47d8027274db40667641829f12ce9c6145022949c564fb4"
  end

  resource "iniparse" do
    url "https://rubygems.org/downloads/iniparse-1.4.4.gem"
    sha256 "9abf3c9daac0ccaad0829b967e1e98b47ffddba9014295b02fd03d34909971f5"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "overcommit.gemspec"
    system "gem", "install", "--ignore-dependencies", "overcommit-#{version}.gem"
    bin.install libexec/"bin/overcommit"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    system "#{bin}/overcommit", "--install"
    assert_predicate testpath/".overcommit.yml", :exist?

    system "git", "add", "-A"
    system "git", "commit", "-m", "test"
  end
end
