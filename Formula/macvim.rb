# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  version "8.1-157"
  head "https://github.com/macvim-dev/macvim.git"

  # Issue #44995, needed for XCode 11, drop after snapshot-157
  stable do
    url "https://github.com/macvim-dev/macvim/archive/snapshot-157.tar.gz"
    sha256 "6447bce4ec7b7f67327da8f7b2e9d4f4b748c1afb90f781fecb6b4a3f54cf0a0"
    patch do
      url "https://github.com/macvim-dev/macvim/pull/946.patch?full_index=1"
      sha256 "662548205298fa918606009e3e99151d760f2f042ef2a59215845b14cdb4e85d"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "d0efe672648dd09076475e7f156ddd722db90777fa3f9af168ce63918a5c47fd" => :catalina
    sha256 "6c96e84a5e91cd87cd37f53b84a117ff723ba145db106da730bc97ca7ac6a6d3" => :mojave
    sha256 "8a76a12ff51b2a685400ae53ae986faf28a870a7a0b91688db5abfa770faa863" => :high_sierra
  end

  depends_on :xcode => :build
  depends_on "cscope"
  depends_on "lua"
  depends_on "python"

  conflicts_with "vim",
    :because => "vim and macvim both install vi* binaries"

  def install
    # Avoid issues finding Ruby headers
    if MacOS.version == :sierra || MacOS.version == :yosemite
      ENV.delete("SDKROOT")
    end

    # MacVim doesn't have or require any Python package, so unset PYTHONPATH
    ENV.delete("PYTHONPATH")

    # make sure that CC is set to "clang"
    ENV.clang

    system "./configure", "--with-features=huge",
                          "--enable-multibyte",
                          "--with-macarchs=#{MacOS.preferred_arch}",
                          "--enable-perlinterp",
                          "--enable-rubyinterp",
                          "--enable-tclinterp",
                          "--enable-terminal",
                          "--with-tlib=ncurses",
                          "--with-compiledby=Homebrew",
                          "--with-local-dir=#{HOMEBREW_PREFIX}",
                          "--enable-cscope",
                          "--enable-luainterp",
                          "--with-lua-prefix=#{Formula["lua"].opt_prefix}",
                          "--enable-luainterp",
                          "--enable-python3interp"
    system "make"

    prefix.install "src/MacVim/build/Release/MacVim.app"
    bin.install_symlink prefix/"MacVim.app/Contents/bin/mvim"

    # Create MacVim vimdiff, view, ex equivalents
    executables = %w[mvimdiff mview mvimex gvim gvimdiff gview gvimex]
    executables += %w[vi vim vimdiff view vimex]
    executables.each { |e| bin.install_symlink "mvim" => e }
  end

  test do
    output = shell_output("#{bin}/mvim --version")
    assert_match "+ruby", output

    # Simple test to check if MacVim was linked to Homebrew's Python 3
    py3_exec_prefix = Utils.popen_read("python3-config", "--exec-prefix")
    assert_match py3_exec_prefix.chomp, output
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"mvim", "-v", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", (testpath/"test.txt").read.chomp
  end
end
