class GitRemoteGcrypt < Formula
  desc "PGP-encrypted git remotes"
  homepage "https://spwhitton.name/tech/code/git-remote-gcrypt/"
  url "https://github.com/spwhitton/git-remote-gcrypt/archive/1.0.2.tar.gz"
  sha256 "002994d60d4b3c9a93452d2655bdf3e761c581159431f743d0827127d88f7be2"

  bottle do
    cellar :any_skip_relocation
    sha256 "5507a6823f636c47bed93584d6f4c971b6edab8926403b487e629537d25e84b6" => :high_sierra
    sha256 "a8c68330aab705412ea4db8752147fe58be7fd7883ff9cbeb8a38db1012daaa0" => :sierra
    sha256 "e1bcadca31a1c8518ece8d2c4fcf3d526617a430e26640b293d95999828218b5" => :el_capitan
  end

  depends_on "docutils" => :build
  depends_on :gpg => :run

  def install
    inreplace "./install.sh", "rst2man", "rst2man.py"

    ENV["prefix"] = prefix

    system "./install.sh"
  end

  test do
    assert_match("fetch\npush\n", pipe_output("#{bin}/git-remote-gcrypt", "capabilities\n", 0))
  end
end
