class Mandoc < Formula
  desc "The mandoc UNIX manpage compiler toolset"
  homepage "http://mdocml.bsd.lv"
  url "http://mdocml.bsd.lv/snapshots/mdocml-1.13.3.tar.gz"
  sha256 "23ccab4800d50bf4c327979af5d4aa1a6a2dc490789cb67c4c3ac1bd40b8cad8"

  head "anoncvs@mdocml.bsd.lv:/cvs", :module => "mdocml", :using => :cvs

  bottle do
    rebuild 1
    sha256 "a73b9ce04e2aa4a89e004fd16c8321cf0e88186d87c45489fea51cead1b325f8" => :sierra
    sha256 "1d0c4b675d172e2b80558a89ffcca966c807d97a73a77d1b4fbd5f5f9f7226ae" => :el_capitan
    sha256 "80e3f89a661d915f3ab1dec6b1bf047e76afb3574b3e8000e24dac3bf94d4218" => :yosemite
  end

  option "without-sqlite", "Only install the mandoc/demandoc utilities."
  option "without-cgi", "Don't build man.cgi (and extra CSS files)."

  depends_on "sqlite" => :recommended

  def install
    localconfig = [

      # Sane prefixes.
      "PREFIX=#{prefix}",
      "INCLUDEDIR=#{include}",
      "LIBDIR=#{lib}",
      "MANDIR=#{man}",
      "WWWPREFIX=#{prefix}/var/www",
      "EXAMPLEDIR=#{share}/examples",

      # Executable names, where utilities would be replaced/duplicated.
      # The mdocml versions of the utilities are definitely *not* ready
      # for prime-time on Darwin, though some changes in HEAD are promising.
      # The "bsd" prefix (like bsdtar, bsdmake) is more informative than "m".
      "BINM_MAN=bsdman",
      "BINM_APROPOS=bsdapropos",
      "BINM_WHATIS=bsdwhatis",
      "BINM_MAKEWHATIS=bsdmakewhatis",	# default is "makewhatis".

      # These are names for *section 7* pages only. Several other pages are
      # prefixed "mandoc_", similar to the "groff_" pages.
      "MANM_MAN=man",
      "MANM_MDOC=mdoc",
      "MANM_ROFF=mandoc_roff", # This is the only one that conflicts (groff).
      "MANM_EQN=eqn",
      "MANM_TBL=tbl",

      "OSNAME='Mac OS X #{MacOS.version}'", # Bottom corner signature line.

      # Not quite sure what to do here. The default ("/usr/share", etc.) needs
      # sudoer privileges, or will error. So just brew's manpages for now?
      "MANPATH_DEFAULT=#{HOMEBREW_PREFIX}/share/man",

      "HAVE_MANPATH=0",   # Our `manpath` is a symlink to system `man`.
      "STATIC=",          # No static linking on Darwin.

      "HOMEBREWDIR=#{HOMEBREW_CELLAR}" # ? See configure.local.example, NEWS.
    ]

    localconfig << "BUILD_DB=1" if build.with? "db"
    localconfig << "BUILD_CGI=1" if build.with? "cgi"
    File.rename("cgi.h.example", "cgi.h") # For man.cgi, harmless in any case.

    (buildpath/"configure.local").write localconfig.join("\n")
    system "./configure"

    # I've tried twice to send a bug report on this to tech@mdocml.bsd.lv.
    # In theory, it should show up with:
    # search.gmane.org/?query=jobserver&group=gmane.comp.tools.mdocml.devel
    ENV.deparallelize do
      system "make"
      system "make", "install"
    end

    system "make", "manpage" # Left out of the install for some reason.
    bin.install "manpage"
  end

  test do
    system "#{bin}/mandoc", "-Thtml",
      "-Ostyle=#{share}/examples/example.style.css",
      "#{HOMEBREW_PREFIX}/share/man/man1/brew.1"
  end
end
