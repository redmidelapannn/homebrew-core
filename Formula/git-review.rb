class GitReview < Formula
  desc "Submit git branches to gerrit for review"
  homepage "https://git.openstack.org/cgit/openstack-infra/git-review"
  url "https://files.pythonhosted.org/packages/source/g/git-review/git-review-1.25.0.tar.gz"
  sha256 "087e0a7dc2415796a9f21c484a6f652c5410e6ba4562c36291c5399f9395a11d"
  head "https://git.openstack.org/openstack-infra/git-review.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6827fd71454afaaf6a47c5581da4bff4e0ca7c1ef31b4738b921537c28b0f7f6" => :high_sierra
    sha256 "b82b32d037d6a208a5fe19247ca5eb94fbe2870d05848ab8e6090186e6f6b4b9" => :sierra
    sha256 "4907c4e45fccde8f1285b3098e44142825cb30bdadca8af65f68ce8c6396c8f2" => :el_capitan
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "requests" do
    url "https://files.pythonhosted.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/vendor/lib/python2.7/site-packages"
    resource("requests").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    man1.install gzip("git-review.1")

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "git", "init"
    system "git", "remote", "add", "gerrit", "https://github.com/Homebrew/homebrew.github.io"
    (testpath/".git/hooks/commit-msg").write "# empty - make git-review happy"
    (testpath/"foo").write "test file"
    system "git", "add", "foo"
    system "git", "commit", "-m", "test"
    system "#{bin}/git-review", "--dry-run"
  end
end
