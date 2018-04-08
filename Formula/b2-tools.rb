class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v1.1.0.tar.gz"
  sha256 "fae0dd48a2b6ab38cb142b91d7907a66144659d599bdfbf3c8995788ed29313b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5df2e9ba446f47fe88138303e979e402b86c7b0fd11a262a73664798cca130e8" => :high_sierra
    sha256 "ce4afd67060bbc982cc9d140dd721bb4189bf458b374808365ec2bd323b19566" => :sierra
    sha256 "8e7faf054abb0e20257d3fb0aea4caeecdeeaa9d4d62f89a123a9ef0efdc4ad8" => :el_capitan
  end

  depends_on "python@2"

  conflicts_with "boost-build", :because => "both install `b2` binaries"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "b2"
    venv.pip_install_and_link buildpath

    bash_completion.install "contrib/bash_completion/b2" => "b2-tools-completion.bash"
    pkgshare.install (buildpath/"contrib").children
  end

  test do
    cmd = "#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1"
    assert_match "bad_auth_token", shell_output(cmd, 1)
  end
end
