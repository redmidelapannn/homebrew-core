class Vit < Formula
  include Language::Python::Virtualenv

  desc "Full-screen terminal interface for Taskwarrior"
  homepage "https://taskwarrior.org/news/news.20140406.html"
  url "https://github.com/scottkosty/vit/archive/v2.0.0.tar.gz"
  sha256 "0c8739c16b5922880e762bd38f887240923d16181b2f85bb88c4f9f6faf38d6d"
  head "https://github.com/scottkosty/vit.git", :branch => "2.x"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "645ccc2d6ef7c7a5da1974900c166adecce393c141dfe2387c85f69c5400504f" => :catalina
    sha256 "155449007526baab7322a7e9b14e17159b9c80856d0e9a3540f56edb80807384" => :mojave
    sha256 "008c06945c8bbd88676955d9913025ecc7aca698536bcd9d6beabd57c80dba47" => :high_sierra
  end

  depends_on "python"
  depends_on "task"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    (testpath/".vit").mkpath
    touch testpath/".vit/config.ini"
    touch testpath/".taskrc"

    require "pty"
    PTY.spawn(bin/"vit") do |_stdout, _stdin, pid|
      sleep 3
      Process.kill "TERM", pid
    end
    assert_predicate testpath/".task", :exist?
  end
end
