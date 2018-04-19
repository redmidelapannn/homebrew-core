class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/1.0.1.tar.gz"
  sha256 "f2b6fde649a66709856c2497a95142db752de75db11cf22ae54ec9ac4b768c8b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "35e3dbebc5d44c18c50e96b44142a6bbeaa741b06007d125c88d558316b5c7b7" => :high_sierra
    sha256 "24eba873cb245b486e7da3f280cc7c54930a89589521b77ee2ae279aaf621943" => :sierra
    sha256 "746f3c99c362a4f1d06ccbc71f505bff137306c7ca9824255e242c85d2f18398" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    srcpath = buildpath/"src/github.com/akamai/cli"
    srcpath.install buildpath.children

    cd srcpath do
      system "glide", "install"
      system "go", "build", "-tags", "noautoupgrade nofirstrun", "-o", bin/"akamai"
      prefix.install_metafiles
    end

    output = <<~EOS
      _akamai_cli_bash_autocomplete() {
          local cur opts base
          COMPREPLY=()
          cur="${COMP_WORDS[COMP_CWORD]}"
          opts=$( ${COMP_WORDS[@]:0:$COMP_CWORD} --generate-auto-complete )
          COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
          return 0
      }
      complete -F _akamai_cli_bash_autocomplete akamai
    EOS
    (bash_completion/"akamai").write output

    (zsh_completion/"_akamai").write <<~EOS
      set -k
      autoload -U compinit && compinit
      autoload -U bashcompinit && bashcompinit
    EOS
    (zsh_completion/"_akamai").append_lines output
  end

  test do
    assert_match "Purge", shell_output("#{bin}/akamai install --force purge")
  end
end
