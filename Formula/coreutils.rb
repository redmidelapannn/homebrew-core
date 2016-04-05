class Coreutils < Formula
  desc "GNU File, Shell, and Text utilities"
  homepage "https://www.gnu.org/software/coreutils"
  url "http://ftpmirror.gnu.org/coreutils/coreutils-8.25.tar.xz"
  mirror "https://ftp.gnu.org/gnu/coreutils/coreutils-8.25.tar.xz"
  sha256 "31e67c057a5b32a582f26408c789e11c2e8d676593324849dcf5779296cdce87"
  revision 1

  bottle do
    sha256 "fb79263cbef096d131f5720b7f6c238b7821e39bc2e07939af58b8bd57d286de" => :el_capitan
    sha256 "42998078451a844f611f30bd9dc46d9fbe20f35397a4af851a0d0b3f023448b9" => :yosemite
    sha256 "1bbde32f40ee78e50c73405a032af787b3f8371eec9c6a984c1446fa2d2996b3" => :mavericks
  end

  conflicts_with "ganglia", :because => "both install `gstat` binaries"
  conflicts_with "idutils", :because => "both install `gid` and `gid.1`"
  conflicts_with "aardvark_shell_utils", :because => "both install `realpath` binaries"

  head do
    url "git://git.sv.gnu.org/coreutils"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "texinfo" => :build
    depends_on "xz" => :build
    depends_on "wget" => :build
  end

  depends_on "gmp" => :optional

  patch :DATA

  def install
    # Work around unremovable, nested dirs bug that affects lots of
    # GNU projects. See:
    # https://github.com/Homebrew/homebrew/issues/45273
    # https://github.com/Homebrew/homebrew/issues/44993
    # This is thought to be an el_capitan bug:
    # http://lists.gnu.org/archive/html/bug-tar/2015-10/msg00017.html
    if MacOS.version == :el_capitan
      ENV["gl_cv_func_getcwd_abort_bug"] = "no"
    end

    system "./bootstrap" if build.head?
    args = %W[
      --prefix=#{prefix}
      --program-prefix=g
    ]
    args << "--without-gmp" if build.without? "gmp"
    system "./configure", *args
    system "make", "install"

    # Symlink all commands into libexec/gnubin without the 'g' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec/"gnubin").install_symlink bin/"g#{cmd}" => cmd
    end
    # Symlink all man(1) pages into libexec/gnuman without the 'g' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/"gnuman"/"man1").install_symlink man1/"g#{cmd}" => cmd
    end

    # Symlink non-conflicting binaries
    bin.install_symlink "grealpath" => "realpath"
    man1.install_symlink "grealpath.1" => "realpath.1"
  end

  def caveats; <<-EOS.undent
    All commands have been installed with the prefix 'g'.

    If you really need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"

    Additionally, you can access their man pages with normal names if you add
    the "gnuman" directory to your MANPATH from your bashrc as well:

        MANPATH="#{opt_libexec}/gnuman:$MANPATH"

    EOS
  end

  def coreutils_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"
      filenames << path.basename.to_s.sub(/^g/, "")
    end
    filenames.sort
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system "#{bin}/gsha1sum", "-c", "test.sha1"
  end
end

__END__
--- coreutils-8.25.orig/NEWS
+++ coreutils-8.25/NEWS
@@ -71,9 +71,6 @@ GNU coreutils NEWS
   df now prefers sources towards the root of a device when
   eliding duplicate bind mounted entries.

-  ls now quotes file names unambiguously and appropriate for use in a shell,
-  when outputting to a terminal.
-
   join, sort, uniq with --zero-terminated, now treat '\n' as a field delimiter.

 ** Improvements
--- coreutils-8.25.orig/src/ls.c
+++ coreutils-8.25/src/ls.c
@@ -1581,7 +1581,6 @@ decode_switches (int argc, char **argv)
       if (isatty (STDOUT_FILENO))
         {
           format = many_per_line;
-          set_quoting_style (NULL, shell_escape_quoting_style);
           /* See description of qmark_funny_chars, above.  */
           qmark_funny_chars = true;
         }
