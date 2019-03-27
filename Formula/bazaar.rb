class Bazaar < Formula
  desc "Friendly powerful distributed version control system"
  homepage "https://bazaar.canonical.com/"
  url "https://launchpad.net/bzr/2.7/2.7.0/+download/bzr-2.7.0.tar.gz"
  sha256 "0d451227b705a0dd21d8408353fe7e44d3a5069e6c4c26e5f146f1314b8fdab3"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "39262a4ea92b579164edc63b503a0aec0ee46c7e4c1ab76e9f6ae8879b790095" => :mojave
    sha256 "a19b7ba39b63c1efe2cc09d4e20eefb22d9b1dd6c3f4073b175f72e01f853fa9" => :high_sierra
    sha256 "d25b40412def6b345596a93c85d9ff04fd673b5f543381d3b88322167d66396a" => :sierra
  end

  # CVE-2017-14176
  # https://bugs.launchpad.net/brz/+bug/1710979
  patch do
    url "https://deb.debian.org/debian/pool/main/b/bzr/bzr_2.7.0+bzr6622-9.debian.tar.xz"
    sha256 "fef6f9a8c3e2f227bf42d0f2f93ea60251a60cb420f7b561d97f0eb685f6ecb6"
    apply "patches/27_fix_sec_ssh"
  end

  def install
    ENV.deparallelize # Builds aren't parallel-safe

    # Make and install man page first
    system "make", "man1/bzr.1"
    man1.install "man1/bzr.1"

    # Put system Python first in path
    ENV.prepend_path "PATH", "/System/Library/Frameworks/Python.framework/Versions/Current/bin"

    system "make"
    inreplace "bzr", "#! /usr/bin/env python", "#!/usr/bin/python"
    libexec.install "bzr", "bzrlib"

    (bin/"bzr").write_env_script(libexec/"bzr", :BZR_PLUGIN_PATH => "+user:#{HOMEBREW_PREFIX}/share/bazaar/plugins")
  end

  test do
    bzr = "#{bin}/bzr"
    whoami = "Homebrew"
    system bzr, "whoami", whoami
    assert_match whoami, shell_output("#{bin}/bzr whoami")
    system bzr, "init-repo", "sample"
    system bzr, "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system bzr, "add", "test.txt"
      system bzr, "commit", "-m", "test"
    end
  end
end
