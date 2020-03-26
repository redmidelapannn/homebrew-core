class Volt < Formula
  desc "Meta-level vim package manager"
  homepage "https://github.com/vim-volt/volt"
  url "https://github.com/vim-volt/volt.git",
    :tag      => "v0.3.7",
    :revision => "e604467d8b440c89793b2e113cd241915e431bf9"
  head "https://github.com/vim-volt/volt.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9c6eac64478fd6896dea25fd3f81bcca7e7c983647021d827ebe77393dfb0229" => :catalina
    sha256 "5fc2c81b4fa5883b6c637e8fc5d3ca20d90a16d2e5ecaa82866f17bb13a6df56" => :mojave
    sha256 "2cd2951d51529f246668b772150e550fc00297ce6de8209a18d8d4e83b2610fd" => :high_sierra
  end

  depends_on "go" => :build

  # Go 1.14+ compatibility.
  patch do
    url "https://github.com/vim-volt/volt/commit/aa9586901d249aa40e67bc0b3e0e7d4f13d5a88b.patch?full_index=1"
    sha256 "62bed17b5c58198f44a669e41112335928e2fa93d71554aa6bddc782cf124872"
  end

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"volt"
    prefix.install_metafiles

    bash_completion.install "_contrib/completion/bash" => "volt"
    zsh_completion.install "_contrib/completion/zsh" => "_volt"
    cp "#{bash_completion}/volt", "#{zsh_completion}/volt-completion.bash"
  end

  test do
    mkdir_p testpath/"volt/repos/localhost/foo/bar/plugin"
    File.write(testpath/"volt/repos/localhost/foo/bar/plugin/baz.vim", "qux")
    system bin/"volt", "get", "localhost/foo/bar"
    assert_equal File.read(testpath/".vim/pack/volt/opt/localhost_foo_bar/plugin/baz.vim"), "qux"
  end
end
