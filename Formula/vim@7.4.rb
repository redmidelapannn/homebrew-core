class VimAT74 < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  url "https://github.com/vim/vim/archive/v7.4.2367.tar.gz"
  sha256 "a9ae4031ccd73cc60e771e8bf9b3c8b7f10f63a67efce7f61cd694cd8d7cda5c"
  revision 7

  bottle do
    rebuild 1
    sha256 "4992b9d7d53be7476e7660ee84d740507544fcef9d32b1913f3df66587bff87e" => :high_sierra
    sha256 "3b11493d0c41c132b9265a85368003dedf41ddc3a2a98fabef9771f706d24a40" => :sierra
    sha256 "64c5bc34ba95d8ce58e09daa5295b32dffa6c9fe8edad41becd4e9d4abebe348" => :el_capitan
  end

  keg_only :versioned_formula

  option "with-override-system-vi", "Override system vi"
  option "without-nls", "Build vim without National Language Support (translated messages, keymaps)"
  option "with-client-server", "Enable client/server mode"

  LANGUAGES_OPTIONAL = %w[lua mzscheme python3 tcl].freeze
  LANGUAGES_DEFAULT  = %w[python].freeze

  option "with-python3", "Build vim with python3 instead of python[2] support"
  LANGUAGES_OPTIONAL.each do |language|
    option "with-#{language}", "Build vim with #{language} support"
  end
  LANGUAGES_DEFAULT.each do |language|
    option "without-#{language}", "Build vim without #{language} support"
  end

  depends_on "perl"
  depends_on "ruby"
  depends_on "python" => :recommended
  depends_on "lua" => :optional
  depends_on "luajit" => :optional
  depends_on "python3" => :optional
  depends_on :x11 if build.with? "client-server"

  def install
    ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"

    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")
    ENV["LUA_PREFIX"] = HOMEBREW_PREFIX if build.with?("lua") || build.with?("luajit")

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete("PYTHONPATH")

    opts = ["--enable-perlinterp", "--enable-rubyinterp"]

    (LANGUAGES_OPTIONAL + LANGUAGES_DEFAULT).each do |language|
      opts << "--enable-#{language}interp" if build.with? language
    end

    if opts.include?("--enable-pythoninterp") && opts.include?("--enable-python3interp")
      # only compile with either python or python3 support, but not both
      # (if vim74 is compiled with +python3/dyn, the Python[3] library lookup segfaults
      # in other words, a command like ":py3 import sys" leads to a SEGV)
      opts -= %w[--enable-pythoninterp]
    end

    opts << "--disable-nls" if build.without? "nls"
    opts << "--enable-gui=no"

    if build.with? "client-server"
      opts << "--with-x"
    else
      opts << "--without-x"
    end

    if build.with? "luajit"
      opts << "--with-luajit"
      opts << "--enable-luainterp"
    end

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    # Homebrew will use the first suitable Perl & Ruby in your PATH if you
    # build from source. Please don't attempt to hardcode either.
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--enable-cscope",
                          "--with-compiledby=Homebrew",
                          *opts
    system "make"
    # Parallel install could miss some symlinks
    # https://github.com/vim/vim/issues/1031
    ENV.deparallelize
    # If stripping the binaries is enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # https://github.com/vim/vim/issues/114
    system "make", "install", "prefix=#{prefix}", "STRIP=#{which "true"}"
    bin.install_symlink "vim" => "vi" if build.with? "override-system-vi"
  end

  test do
    # Simple test to check if Vim was linked to Python version in $PATH
    if build.with? "python"
      vim_path = bin/"vim"

      # Get linked framework using otool
      otool_output = `otool -L #{vim_path} | grep -m 1 Python`.gsub(/\(.*\)/, "").strip.chomp

      # Expand the link and get the python exec path
      vim_framework_path = Pathname.new(otool_output).realpath.dirname.to_s.chomp
      python_framework_path = `python2-config --exec-prefix`.chomp

      assert_equal python_framework_path, vim_framework_path
    end
  end
end
