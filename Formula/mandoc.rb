class Mandoc < Formula
  desc "The mandoc UNIX manpage compiler toolset"
  homepage "https://mandoc.bsd.lv/"
  url "https://mandoc.bsd.lv/snapshots/mandoc-1.14.3.tar.gz"
  sha256 "0b0c8f67958c1569ead4b690680c337984b879dfd2ad4648d96924332fd99528"

  head "anoncvs@mandoc.bsd.lv:/cvs", :using => :cvs

  bottle do
    rebuild 1
    sha256 "9dc293c7d81883510385a1ce4603de18d6ed23c90b9ddd43857fb19cda137f65" => :high_sierra
    sha256 "fcc2655cb1654b0188bc3f4295e0d514841d4dbfb25468c070a26afdd4eb6cad" => :sierra
    sha256 "05482538ff8a3e634c9104036b370d906f8a87087e688236b0653cae4f4fe445" => :el_capitan
  end

  option "without-cgi", "Don't build man.cgi (and extra CSS files)."

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
      # The mandoc versions of the utilities are definitely *not* ready
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
  end

  test do
    system "#{bin}/mandoc", "-Thtml",
      "-Ostyle=#{share}/examples/example.style.css", "#{man1}/mandoc.1"
  end
end
