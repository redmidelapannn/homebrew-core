class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v1.4.2.tar.gz"
  sha256 "2d6382b94af59dcaa44dd546252807e0364d1b61f169584829ebbf82458e7078"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "359dc46390fbfc8b78ee10a1ca122b3bae6164030be4db88bfa5458c9bd25306" => :catalina
    sha256 "c7c3ecfe13f1b9ea4091d791f0361f359953c2f1bc5f30774bed11e6e6ba3c31" => :mojave
    sha256 "6c9171b570863d3dc3770d2c5ff22f5ec4925705cd5ff054f150773ba9362a3d" => :high_sierra
  end

  depends_on "python@3.8"

  conflicts_with "boost-build", :because => "both install `b2` binaries"

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "b2"
    venv.pip_install_and_link buildpath

    bash_completion.install "contrib/bash_completion/b2" => "b2-tools-completion.bash"
    pkgshare.install (buildpath/"contrib").children
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    cmd = "#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1"
    assert_match "unable to authorize account", shell_output(cmd, 1)
  end
end
