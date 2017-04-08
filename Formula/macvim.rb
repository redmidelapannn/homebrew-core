# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  url "https://github.com/macvim-dev/macvim/archive/snapshot-130.tar.gz"
  version "8.0-130"
  sha256 "5dd5895b35341a4a5f65f2a61dd730ba9e1c336ac04cfed64c154142ce18db0c"
  head "https://github.com/macvim-dev/macvim.git"

  bottle do
    rebuild 1
    sha256 "31f6766fd322b2a59a5fef0c2917a23e2517c94499f96e23081688ec4c776399" => :sierra
    sha256 "0c89875fdbdc52a81ae00077eb43661a91bd7fa27b846137fdd7ea3bec23a975" => :el_capitan
    sha256 "afdc869d108f9820dac4a16214654fd951f5c849056789369fd24672e848eabd" => :yosemite
  end

  option "with-override-system-vim", "Override system vim"

  deprecated_option "override-system-vim" => "with-override-system-vim"

  conflicts_with "vim",
    :because => "They both override system vim" if build.with? "override-system-vim"

  depends_on :xcode => :build
  depends_on "cscope" => :recommended
  depends_on "lua" => :optional
  depends_on "luajit" => :optional
  depends_on "gettext" => :optional

  if MacOS.version >= :mavericks
    option "with-custom-python", "Build with a custom Python 2 instead of the Homebrew version."
  end

  option "with-ruby", "Build with brewed ruby instead of the system version"
  option "with-perl", "Build with brewed perl instead of the system version"

  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on "ruby" => :optional
  depends_on "perl" => :optional
  depends_on "homebrew/dupes/ncurses" => :optional
  depends_on "homebrew/dupes/libiconv" => :optional

  def install
    # Avoid "fatal error: 'ruby/config.h' file not found"
    ENV.delete("SDKROOT") if MacOS.version == :yosemite

    # MacVim doesn't have or require any Python package, so unset PYTHONPATH
    ENV.delete("PYTHONPATH")

    # If building for OS X 10.7 or up, make sure that CC is set to "clang"
    ENV.clang if MacOS.version >= :lion

    args = %W[
      --with-features=huge
      --enable-multibyte
      --with-macarchs=#{MacOS.preferred_arch}
      --enable-perlinterp
      --enable-rubyinterp
      --enable-tclinterp
      --with-tlib=ncurses
      --with-compiledby=Homebrew
      --with-local-dir=#{HOMEBREW_PREFIX}
    ]

    args << "--enable-cscope" if build.with? "cscope"

    if build.with? "lua"
      args << "--enable-luainterp"
      args << "--with-lua-prefix=#{Formula["lua"].opt_prefix}"
    end

    if build.with? "luajit"
      args << "--enable-luainterp"
      args << "--with-lua-prefix=#{Formula["luajit"].opt_prefix}"
      args << "--with-luajit"
    end

    # Allow python or python3, but not both; if the optional
    # python3 is chosen, default to it; otherwise, use python2
    if build.with? "python3"
      args << "--enable-python3interp"
    elsif build.with? "python"
      ENV.prepend "LDFLAGS", `python-config --ldflags`.chomp

      # Needed for <= OS X 10.9.2 with Xcode 5.1
      ENV.prepend "CFLAGS", `python-config --cflags`.chomp.gsub(/-mno-fused-madd /, "")

      framework_script = <<-EOS.undent
        import sysconfig
        print sysconfig.get_config_var("PYTHONFRAMEWORKPREFIX")
      EOS
      framework_prefix = `python -c '#{framework_script}'`.strip
      # Non-framework builds should have PYTHONFRAMEWORKPREFIX defined as ""
      if framework_prefix.include?("/") && framework_prefix != "/System/Library/Frameworks"
        ENV.prepend "LDFLAGS", "-F#{framework_prefix}"
        ENV.prepend "CFLAGS", "-F#{framework_prefix}"
      end
      args << "--enable-pythoninterp"
    end

    args << "--disable-nls" if build.without? "gettext"

    system "./configure", *args
    system "make"

    apppath = "src/MacVim/build/Release/MacVim.app"

    if build.with? "gettext"
      system "INSTALL_DATA=install " +
             "FILEMOD=644 " +
             "LOCALEDIR=../../#{apppath}/Contents/Resources/vim/runtime/lang " +
             "make -C src/po install"
    end

    prefix.install apppath

    inreplace "src/MacVim/mvim", %r{^# VIM_APP_DIR=\/Applications$},
                                 "VIM_APP_DIR=#{prefix}"
    bin.install "src/MacVim/mvim"

    # Create MacVim vimdiff, view, ex equivalents
    executables = %w[mvimdiff mview mvimex gvim gvimdiff gview gvimex]
    executables += %w[vi vim vimdiff view vimex] if build.with? "override-system-vim"
    executables.each { |e| bin.install_symlink "mvim" => e }
  end

  def caveats
    if build.with?("python") && build.with?("python3")
      <<-EOS.undent
        MacVim can no longer be brewed with dynamic support for both Python versions.
        Only Python 3 support has been provided.
      EOS
    end
  end

  test do
    # Simple test to check if MacVim was linked to Python version in $PATH
    if build.with? "python3"
      system_framework_path = `python3-config --exec-prefix`.chomp
      assert_match system_framework_path, `mvim --version`
    elsif build.with? "python"
      system_framework_path = `python-config --exec-prefix`.chomp
      assert_match system_framework_path, `mvim --version`
    end

    # Check whether MacVim is built with +gettext
    if build.with? "gettext"
      assert_match "+gettext", `#{bin}/mvim --version`
    end

    # Check if MacVim was linked to Ruby version in $PATH
    if build.with? "ruby"
      ruby_ver = `ruby -e 'print(RUBY_VERSION)'`.chomp
      assert_match "-lruby." + ruby_ver, `#{bin}/mvim --version`
    end
  end
end
