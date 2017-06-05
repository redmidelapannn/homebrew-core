class C < Formula
  desc "Git utility script to switch between recent branches"
  homepage "https://github.com/AndrewRayCode/c"
  url "https://github.com/AndrewRayCode/c-releases/raw/master/c-0.0.2.tar.gz"
  sha256 "a20071425f7b91d3f37c9f2a9af3a0c643588dce4f2466a4ea197e42b707ccfb"

  bottle do
    cellar :any_skip_relocation
    sha256 "65a42d47c8887775e34523d7091a3e1f37082584bb39d046daf8e8faf9a45ef5" => :sierra
    sha256 "d3036cd6bef3d9c44d836870122950c507f9adb15dd909a00069d77b9cf4329e" => :el_capitan
    sha256 "d3036cd6bef3d9c44d836870122950c507f9adb15dd909a00069d77b9cf4329e" => :yosemite
  end

  def install
    bin.install %w[c c_recent_branches_completer]
  end

  def caveats; <<-EOS.undent
    ⚠️  To get command line completion for c, add the following to your .bashrc

    # Set up tab completion for git completion 'c' utility script
    if [[ -d "$(brew --prefix c)" ]]; then
        source "$(brew --prefix c)/c_recent_branches_completer"
    fi
    EOS
  end
end

