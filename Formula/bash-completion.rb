# NOTE: version 2 is out, but it requires Bash 4, and macOS ships
# with 3.2.57. If you've upgraded bash, use bash-completion@2 instead.
class BashCompletion < Formula
  desc "Programmable completion for Bash 3.2"
  homepage "https://salsa.debian.org/debian/bash-completion"
  url "https://src.fedoraproject.org/repo/pkgs/bash-completion/bash-completion-1.3.tar.bz2/a1262659b4bbf44dc9e59d034de505ec/bash-completion-1.3.tar.bz2"
  sha256 "8ebe30579f0f3e1a521013bcdd183193605dab353d7a244ff2582fb3a36f7bec"
  revision 3

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "74d30644bb757f3b188d062600e576192f1d890e8d11baa46af54275893b5e0f" => :mojave
    sha256 "74d30644bb757f3b188d062600e576192f1d890e8d11baa46af54275893b5e0f" => :high_sierra
    sha256 "1258fbfcd8d013c9d8f59cad9a4a2a199524e6f0726d912ab3d4688054ce0eb2" => :sierra
  end

  conflicts_with "bash-completion@2", :because => "Differing version of same formula"

  # Backports the following upstream patch from 2.x:
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=740971
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c1d87451da3b5b147bed95b2dc783a1b02520ac5/bash-completion/bug-740971.patch"
    sha256 "bd242a35b8664c340add068bcfac74eada41ed26d52dc0f1b39eebe591c2ea97"
  end

  # Backports (a variant of) an upstream patch to fix man completion.
  patch :DATA

  # Backports ssh_config Include directive parsing for ssh hostname tab
  # completion
  patch :p0 do
    url "https://gist.githubusercontent.com/timvisher/93444e4ca4e1ad9cc2eb90c1d71294e3/raw/2277a816bfeead13744244cb9d906422ad0d442b/ssh_config_include_1.3_homebrew_backport.patch"
    sha256 "b9f899d3ed61213ae102ec379cd226cb8aacb756ebd238aa293144975fb2713d"
  end

  def install
    inreplace "bash_completion" do |s|
      s.gsub! "/etc/bash_completion", etc/"bash_completion"
      s.gsub! "readlink -f", "readlink"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    Add the following line to your ~/.bash_profile:
      [[ -r "#{etc}/profile.d/bash_completion.sh" ]] && . "#{etc}/profile.d/bash_completion.sh"
  EOS
  end

  test do
    system "bash", "-c", ". #{etc}/profile.d/bash_completion.sh"
  end
end
__END__
--- a/completions/man
+++ b/completions/man
@@ -27,7 +27,7 @@
     fi

     uname=$( uname -s )
-    if [[ $uname == @(Linux|GNU|GNU/*|FreeBSD|Cygwin|CYGWIN_*) ]]; then
+    if [[ $uname == @(Darwin|Linux|GNU|GNU/*|FreeBSD|Cygwin|CYGWIN_*) ]]; then
         manpath=$( manpath 2>/dev/null || command man --path )
     else
         manpath=$MANPATH
