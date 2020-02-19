class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v2.1.0.tar.gz"
  sha256 "62c09f83cbac0904c9aff0a6412f5db2d10e1756fa6c1fc05eeefa15b677fb80"

  bottle do
    cellar :any_skip_relocation
    sha256 "658e084272c370cd2e65e71438dff66e0d2d083c2dc9b175795ec2e374ad16fd" => :catalina
    sha256 "5d3e1aba1b050060432545b724fba12a8fd7bd1b8b1ac6a62ad0760d8992a1e9" => :mojave
    sha256 "cd0f9e520dc3069994be5ccfd4ba84986701e9239155594e2b44cab84be7446d" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", "PyYAML==5.1.2", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "pre-commit"
    venv.pip_install_and_link buildpath
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    testpath.cd do
      system "git", "init"
      (testpath/".pre-commit-config.yaml").write <<~EOS
        -   repo: https://github.com/pre-commit/pre-commit-hooks
            sha: v0.9.1
            hooks:
            -   id: trailing-whitespace
      EOS
      system bin/"pre-commit", "install"
      (testpath/"f").write "hi\n"
      system "git", "add", "f"

      ENV["GIT_AUTHOR_NAME"] = "test user"
      ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
      ENV["GIT_COMMITTER_NAME"] = "test user"
      ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
      git_exe = which("git")
      ENV["PATH"] = "#{bin}:/usr/bin:/bin"
      system git_exe, "commit", "-m", "test"
    end
  end
end
