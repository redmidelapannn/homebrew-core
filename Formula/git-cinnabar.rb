class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  revision 1
  head "https://github.com/glandium/git-cinnabar.git"

  stable do
    url "https://github.com/glandium/git-cinnabar.git",
        :tag => "0.4.0",
        :revision => "6d374888ff0287517084c0ec7573963961f6acec"

    # 5 Nov 2017 "Support the batch API change from mercurial 4.4"
    patch do
      url "https://github.com/glandium/git-cinnabar/commit/7ea77b0.patch?full_index=1"
      sha256 "e28fdf1b9afa94dbd17289e739cd68af34bf7ae708b827cfa9e23286dbbbb57c"
    end

    # 5 Nov 2017 "Adapt localpeer to sshpeer changes in mercurial 4.4"
    # Backport of https://github.com/glandium/git-cinnabar/commit/5c59ae1
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e56093e/git-cinnabar/mercurial-4.4-sshpeer.patch"
      sha256 "9af333567ff4aec002c947906d9e5a62ce7358c4ffa1edf7be0b5fe0a96b87ae"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "18011a728ed197e3e335513c2642eea15d7fefa04c49527d418a7293df8c26f5" => :high_sierra
    sha256 "13c436082b730a60f8396468fc7041e8726dac2f2873a77e19cacaf76fd1510b" => :sierra
    sha256 "6509db4a8464f3ac522e80725b5d9243ac2964c86330f0f09dc4be6e657c4285" => :el_capitan
  end

  devel do
    url "https://github.com/glandium/git-cinnabar.git",
        :tag => "0.5.0b4",
        :revision => "125ae46f06383fd69c6b9febac9a33317d12b368"
    version "0.5.0b4"
  end

  depends_on "mercurial"

  conflicts_with "git-remote-hg", :because => "both install `git-remote-hg` binaries"

  def install
    system "make", "helper"
    prefix.install "cinnabar"
    bin.install "git-cinnabar", "git-cinnabar-helper", "git-remote-hg"
    bin.env_script_all_files(libexec, :PYTHONPATH => prefix)
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_predicate testpath/"hello/hello.c", :exist?,
                     "hello.c not found in cloned repo"
  end
end
