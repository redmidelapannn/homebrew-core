class Ry < Formula
  desc "Ruby virtual env tool"
  homepage "https://github.com/jayferd/ry"
  url "https://github.com/jayferd/ry/archive/v0.5.2.tar.gz"
  sha256 "b53b51569dfa31233654b282d091b76af9f6b8af266e889b832bb374beeb1f59"
  head "https://github.com/jayferd/ry.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "3b2946d5677615b27f918a8602c75a7859982a8e9d648f636b71155a68355451" => :mojave
    sha256 "5c32fd5c416bf4d53a3397cb8f79c638621c5374a5c2dfac5d66480655c01355" => :high_sierra
    sha256 "5c32fd5c416bf4d53a3397cb8f79c638621c5374a5c2dfac5d66480655c01355" => :sierra
    sha256 "5c32fd5c416bf4d53a3397cb8f79c638621c5374a5c2dfac5d66480655c01355" => :el_capitan
  end

  depends_on "bash-completion"
  depends_on "ruby-build"

  def install
    ENV["PREFIX"] = prefix
    ENV["BASH_COMPLETIONS_DIR"] = etc/"bash_completion.d"
    ENV["ZSH_COMPLETIONS_DIR"] = share/"zsh/site-functions"
    system "make", "install"
  end

  def caveats; <<~EOS
    Please add to your profile:
      which ry &>/dev/null && eval "$(ry setup)"

    If you want your Rubies to persist across updates you
    should set the `RY_RUBIES` variable in your profile, i.e.
      export RY_RUBIES="#{HOMEBREW_PREFIX}/var/ry/rubies"
  EOS
  end

  test do
    ENV["RY_RUBIES"] = testpath/"rubies"

    system bin/"ry", "ls"
    assert_predicate testpath/"rubies", :exist?
  end
end
