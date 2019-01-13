class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.1.4/modules-4.1.4.tar.bz2"
  sha256 "7eaf26b66cbf3ba101ec5a693b7bfb3a47f3c86cad09e47c4126f3d785864c55"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2706bef6b96997069c0846263c04943d9c0f97e3f3941b8f9e94bbc3dc70e2d7" => :mojave
    sha256 "4e6e5564d22ac9e7356eee5963520a402dade9c195201529593c4816cb236244" => :high_sierra
    sha256 "9f110584ad51b48203a31df4330888342ed249f5aa08909bc9cba4a0bc62c08c" => :sierra
  end

  depends_on "grep" => :build # configure checks for ggrep

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"

    # -DUSE_INTERP_ERRORLINE fixes
    # error: no member named 'errorLine' in 'struct Tcl_Interp'
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --datarootdir=#{share}
      --disable-versioning
      --with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework
      --without-x
      CPPFLAGS=-DUSE_INTERP_ERRORLINE
    ]
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<~EOS
    To activate modules, add the following at the end of your .zshrc:
      source #{opt_prefix}/init/zsh
    You will also need to reload your .zshrc:
      source ~/.zshrc
  EOS
  end

  test do
    assert_match "restore", shell_output("#{bin}/envml --help")
    output = shell_output("zsh -c 'source #{prefix}/init/zsh; module' 2>&1")
    assert_match version.to_s, output
  end
end
