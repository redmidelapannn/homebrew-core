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
    sha256 "989150c3f543839b8fe97deb012a8d66fe6d3cbf5e141843f409a369f377bbca" => :high_sierra
    sha256 "0947a39c7502b4f2bdc931b7bfba2c76587871e22a48644673e6e073b0eaf08c" => :sierra
    sha256 "0cd83613d45988d9eb31c2a74893eb2223714f81a911a9a09632bd938840cb59" => :el_capitan
  end

  devel do
    url "https://github.com/glandium/git-cinnabar.git",
        :tag => "0.5.0b2",
        :revision => "419f4d2de0f1f0229ca0900774a576db5668e60e"
    version "0.5.0b2"

    # 7 Jul 2017 "Properly handle the case where there is no file metadata to store"
    # This is needed for the nearly empty test repo below to succeed
    patch do
      url "https://github.com/glandium/git-cinnabar/commit/fbce645.patch?full_index=1"
      sha256 "e905bc05886d212399dac7025f9fb583fed61d1b74679294ed2974c853f8935a"
    end

    # same as in stable
    patch do
      url "https://github.com/glandium/git-cinnabar/commit/7ea77b0.patch?full_index=1"
      sha256 "e28fdf1b9afa94dbd17289e739cd68af34bf7ae708b827cfa9e23286dbbbb57c"
    end

    # same as in stable
    patch do
      url "https://github.com/glandium/git-cinnabar/commit/5c59ae1.patch?full_index=1"
      sha256 "263c13fb9a59ed790957fcf337671b093e0b4d434c37b69cf1d0e03fd2a4102b"
    end
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
