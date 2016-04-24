class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  head "https://github.com/tj/git-extras.git"

  stable do
    url "https://github.com/tj/git-extras/archive/4.1.0.tar.gz"
    sha256 "d4c028e2fe78abde8f3e640b70f431318fb28d82894dde22772efe8ba3563f85"
    # Disable "git extras update", which will produce a broken install under Homebrew
    # https://github.com/Homebrew/homebrew/issues/44520
    # https://github.com/tj/git-extras/pull/491
    patch :DATA
  end

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "af2957551e566fd9ae7c65cfd6a6612574dfc02c44a8543c583015d3e4409274" => :el_capitan
    sha256 "99fdffd182d5e621d6d09ffa9a724e3b64be3f1f9d0d2882cdde1ca1fcfb211b" => :yosemite
    sha256 "cffaaa2ed4631e4db86a671b1302af4a6d69eaf075723bd9d232d10b781606d9" => :mavericks
  end

  conflicts_with "git-town",
    :because => "git-extras also ships a git-sync binary"
  conflicts_with "git-utils",
    :because => "both install a `git-pull-request` script"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "git", "init"
    assert_match(/#{testpath}/, shell_output("#{bin}/git-root"))
  end
end

__END__
diff --git a/bin/git-extras b/bin/git-extras
index 3856179..e2ac72c 100755
--- a/bin/git-extras
+++ b/bin/git-extras
@@ -4,13 +4,12 @@ VERSION="4.0.0"
 INSTALL_SCRIPT="https://raw.githubusercontent.com/tj/git-extras/master/install.sh"

 update() {
-  local bin=$(which git-extras)
-  local prefix=${bin%/*/*}
-  local orig=$PWD
-
-  curl -s $INSTALL_SCRIPT | PREFIX="$prefix" bash /dev/stdin \
-    && cd "$orig" \
-    && echo "... updated git-extras $VERSION -> $(git extras --version)"
+  echo "This git-extras installation is managed by Homebrew."
+  echo "If you'd like to update git-extras, run the following:"
+  echo
+  echo "  brew upgrade git-extras"
+  echo
+  return 1
 }

 updateForWindows() {
